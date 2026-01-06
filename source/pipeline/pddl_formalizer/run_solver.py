import requests
import time
import pandas as pd
import os
import json
import argparse
import math

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to use")
parser.add_argument("--data", help="which dataset to use")
parser.add_argument("--constraint_type", choices=["baseline", "initial", "goal", "state-based", "sequential", "numerical"])
parser.add_argument("--model", help="which model to evaluate")
parser.add_argument("--run_type", help="type of output for the model", choices=["generate", "edit"])
parser.add_argument("--revision", action='store_true')
parser.add_argument("--solver", default="dual-bfws-ffparser")
parser.add_argument("--default", action="store_true")
parser.add_argument("--problems", type=str, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")
parser.add_argument("--constraints", type=str, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")
parser.add_argument("--py2pddl", action='store_true')
args = parser.parse_args()

def get_default(domain, data, constraint_type):
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

def run_solver(domain, data, problem, constraint, model, solver, run_type, constraint_type, revision, py2pddl):
    mode = "revisions/" if revision else "py2pddl/" if py2pddl else ""
    domain_file = open(f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_df.pddl').read()
    problem_file = open(f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_pf.pddl').read()


    req_body = {"domain" : domain_file, "problem" : problem_file}

    # Send job request to solve endpoint
    solve_request_url=requests.post(f"https://solver.planning.domains:5001/package/{solver}/solve", json=req_body).json()

    # Query the result in the job
    celery_result=requests.post('https://solver.planning.domains:5001' + solve_request_url['result'])

    while celery_result.json().get("status","")== 'PENDING':
        # Query the result every 0.5 seconds while the job is executing
        celery_result=requests.post('https://solver.planning.domains:5001' + solve_request_url['result'])
        time.sleep(0.5)
    print(celery_result.json())
    result = celery_result.json()['result']
    return result

def run_solver_batch(domain, model, data, solver, run_type, constraint_type, revision, py2pddl, problems, constraints):
    attempts = 3
    for problem, constraint in zip(problems, constraints):
        print(f"Running {problem}_{constraint}")
        for i in range(attempts):
            try:
                output = run_solver(domain, data, problem, constraint, model, solver, run_type, constraint_type, revision, py2pddl)               
            except Exception as e:
                print(e)
                if i < attempts - 1:
                    continue
                else:
                    raise
            break
        
        
        mode = "revisions/" if revision else "py2pddl/" if py2pddl else ""
        if output["output"]["plan"]:
            output_path = f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_plan.txt'
            result = output["output"]["plan"]
        elif output["stderr"]:
            output_path = f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_error.txt'
            result = output["stderr"]
        else:
            output_path = f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_output.txt'
            result = output["stdout"]

        if not os.path.exists(os.path.dirname(output_path)):
            os.makedirs(os.path.dirname(output_path))

        with open(output_path, 'w') as output_file:
                output_file.write(result)

        time.sleep(2)

def main(domain, data, model, constraint_type, run_type, revision, py2pddl, default, problems, constraints, solver):
    if default:
        problem_names, constraint_names = get_default(domain, data, constraint_type)
    else:
        problem_names, constraint_names = problem_and_constraint_names(problems, constraints)
    
    run_solver_batch(domain, model, data, solver, run_type, constraint_type, revision, py2pddl, problem_names, constraint_names)

if __name__=="__main__":
    args = parser.parse_args()
    domain = args.domain
    data = args.data
    model = args.model
    constraint_type = args.constraint_type
    run_type = args.run_type
    revision = args.revision
    solver = args.solver
    default = args.default
    problems = args.problems
    constraints = args.constraints
    py2pddl = args.py2pddl
    main(domain=domain, data=data, model=model, constraint_type=constraint_type, run_type=run_type, revision=revision, py2pddl=py2pddl, default=default, problems=problems, constraints=constraints, solver=solver)
    