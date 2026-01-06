import requests
import time
import pandas as pd
import os
import json
import argparse
import math
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to use")
parser.add_argument("--data", help="which dataset to use")
parser.add_argument("--constraint_type", choices=["baseline", "action", "state", "initial", "goal", "original"])
parser.add_argument("--model", help="which model to evaluate")
parser.add_argument("--run_type", help="type of output for the model", choices=["generate", "edit"])
parser.add_argument("--revision", action='store_true')
parser.add_argument("--attempt", type=int, help="which attempt to evaluate")
parser.add_argument("--solver", default="dual-bfws-ffparser")
parser.add_argument("--default", action="store_true")
parser.add_argument("--problems", type=str, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")
parser.add_argument("--constraints", type=str, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")

def get_default(domain, data, constraint_type):
    constraint_type = "baseline" if constraint_type == "original" else constraint_type
    jsonl_file_path = f'../../../data/{domain}/{data}/constraints/{constraint_type}/pddl/groundtruth_plan_info.jsonl'
    problems = []
    constraints = []
    with open(jsonl_file_path) as jsonl_file:
        for line in jsonl_file:
            groundtruth_plan_info = json.loads(line)
            
            problem_name = groundtruth_plan_info["problem"]
            constraint_name = groundtruth_plan_info["constraint"]
            problems.append(problem_name)
            constraints.append(constraint_name)
    
    return problems, constraints

def problem_and_constraint_names(problems, constraints):
    problem_numbers = []
    for part in problems.split(","):
        if "-" in part:
            start, end = map(int, part.split("-"))
            problem_numbers.extend(range(start, end+1))
        else:
            problem_numbers.append(int(part))
    problem_names = [f'p0{problem_number}' if problem_number < 10 else f'p{problem_number}' for problem_number in problem_numbers]

    constraint_numbers = []
    for part in constraints.split(","):
        if "-" in part:
            start, end = map(int, part.split("-"))
            constraint_numbers.extend(range(start, end+1))
        else:
            constraint_numbers.append(int(part))
    constraint_names = [f'constraint{constraint_number}' for constraint_number in constraint_numbers]

    return problem_names, constraint_names

def run_solver(domain, data, problem, constraint, model, solver, run_type, constraint_type, revision):
    mode = "revisions/" if revision else ""
    attempt_dir = f"attempt{attempt}/" if attempt else ""
    if constraint_type != "original":
        domain_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{constraint}_{model}_compiled_result/compiled_dom.pddl').read()
        problem_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{constraint}_{model}_compiled_result/compiled_prob.pddl').read()
    else:
        domain_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{model}_compiled_result/compiled_dom.pddl').read()
        problem_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{model}_compiled_result/compiled_prob.pddl').read()


    req_body = {"domain" : domain_file, "problem" : problem_file}

    # Send job request to solve endpoint
    solve_request_url=requests.post(f"https://solver.planning.domains:5001/package/{solver}/solve", json=req_body).json()

    # Query the result in the job
    celery_result=requests.post('https://solver.planning.domains:5001' + solve_request_url['result'])

    while celery_result.json().get("status","")== 'PENDING':
        # Query the result every 0.5 seconds while the job is executing
        celery_result=requests.post('https://solver.planning.domains:5001' + solve_request_url['result'])
        time.sleep(0.5)
    result = celery_result.json()['result']
    return result

def run_solver_batch(domain, model, data, solver, run_type, constraint_type, revision, attempt, problems, constraints):
    attempts = 3
    print(f"Running solver on {domain}_{data}_{model}_{run_type}_{constraint_type}")
    for problem, constraint in zip(problems, constraints):
        print(f"Running {problem}_{constraint}")
        mode = "revisions/" if revision else ""
        attempt_dir = f"attempt{attempt}/" if attempt else ""
        if constraint_type != "original":
            plan_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{constraint}_{model}_plan_raw.txt'
            error_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{constraint}_{model}_error.txt'
            output_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{constraint}_{model}_output.txt'
        else:
            plan_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{model}_plan_raw.txt'
            error_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{model}_error.txt'
            output_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{model}_output.txt'
        if os.path.exists(error_file_path) or os.path.exists(plan_file_path) or os.path.exists(output_file_path):
            continue
        for i in range(attempts):
            try:
                output = run_solver(domain, data, problem, constraint, model, solver, run_type, constraint_type, revision)               
            except Exception as e:
                print(e)
                if i < attempts - 1:
                    continue
                else:
                    raise
            break
        
        if output["output"]["plan"]:
            output_path = plan_file_path
            result = output["output"]["plan"]
            solution_found = True
        elif output["stderr"]:
            output_path = error_file_path
            result = output["stderr"]
            solution_found = False
        else:
            output_path = output_file_path
            result = output["stdout"]
            solution_found = False

        if not os.path.exists(os.path.dirname(output_path)):
            os.makedirs(os.path.dirname(output_path))

        with open(output_path, 'w') as output_file:
                output_file.write(result)

        if solution_found:
            clean_tcore_executable = '../../../../tcore/clean_tcore_sol.py'
            command = ['python', clean_tcore_executable, output_path]
            subprocess.run(command, capture_output=True, text=True, check=True)

            if constraint_type != "original":
                clean_plan_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/clean_{problem}_{constraint}_{model}_plan_raw.txt'
                new_clean_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{constraint}_{model}_plan.txt'
            else:
                    clean_plan_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/clean_{problem}_{model}_plan_raw.txt'
                    new_clean_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{model}_plan.txt'
            os.rename(clean_plan_path, new_clean_path)

def main(domain, data, model, constraint_type, run_type, revision, attempt, default, problems, constraints, solver):
    if default:
        problem_names, constraint_names = get_default(domain, data, constraint_type)
    else:
        problem_names, constraint_names = problem_and_constraint_names(problems, constraints)
    
    run_solver_batch(domain, model, data, solver, run_type, constraint_type, revision, attempt, problem_names, constraint_names)

if __name__=="__main__":
    args = parser.parse_args()
    domain = args.domain
    data = args.data
    model = args.model
    constraint_type = args.constraint_type
    run_type = args.run_type
    revision = args.revision
    attempt = args.attempt
    solver = args.solver
    default = args.default
    problems = args.problems
    constraints = args.constraints
    main(domain=domain, data=data, model=model, constraint_type=constraint_type, run_type=run_type, revision=revision, attempt=attempt, default=default, problems=problems, constraints=constraints, solver=solver)
    