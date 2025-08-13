import requests
import time
import pandas as pd
import os
import json
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to use")
parser.add_argument("--data", help="which dataset to use")
parser.add_argument("--constraint_type", choices=["baseline", "initial", "goal", "state-based", "sequential", "numerical"])
parser.add_argument("--model", help="which model to evaluate")
parser.add_argument("--run_type", help="type of output for the model", choices=["generate", "edit"])
parser.add_argument("--revision", action='store_true')
parser.add_argument("--solver", default="dual-bfws-ffparser")
parser.add_argument("--default", action='store_true')
parser.add_argument("--problem_start", type=int)
parser.add_argument("--problem_end", type=int)
parser.add_argument("--constraint_start", type=int)
parser.add_argument("--constraint_end", type=int)
args = parser.parse_args()

def parse_json_file(domain, data, constraint_type):
    jsonl_file_path = f'../../data/{domain}/{data}/constraints/{constraint_type}/pddl/groundtruth_plan_info.jsonl'
    problem_configs = {}
    with open(jsonl_file_path) as jsonl_file:
        for line in jsonl_file:
            groundtruth_plan_info = json.loads(line)
            
            problem_name = groundtruth_plan_info["problem"]
            constraint_name = groundtruth_plan_info["constraint"]
            plan_exists = groundtruth_plan_info["plan_exists"]
            problem_configs.setdefault(problem_name, {})[constraint_name] = plan_exists
    
    return problem_configs

def run_solver(domain, data, problem, constraint, model, solver, run_type, constraint_type, revision):

    domain_file = open(f'../../output/llm-as-formalizer/{domain}/{data}/{"revisions/" if revision else ""}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_df.pddl').read()
    problem_file = open(f'../../output/llm-as-formalizer/{domain}/{data}/{"revisions/" if revision else ""}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_pf.pddl').read()


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

def run_solver_batch(domain, model, data, solver, run_type, constraint_type, revision, problems, constraints):
    attempts = 3
    for problem, constraint in zip(problems, constraints):
        print(f"Running {problem}_{constraint}")
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
            output_path = f'../../output/llm-as-formalizer/{domain}/{data}/{"revisions/" if revision else ""}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_plan.txt'
            result = output["output"]["plan"]
        elif output["stderr"]:
            output_path = f'../../output/llm-as-formalizer/{domain}/{data}/{"revisions/" if revision else ""}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_error.txt'
            result = output["stderr"]
        else:
            output_path = f'../../output/llm-as-formalizer/{domain}/{data}/{"revisions/" if revision else ""}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_output.txt'
            result = output["stdout"]

        if not os.path.exists(os.path.dirname(output_path)):
            os.makedirs(os.path.dirname(output_path))

        with open(output_path, 'w') as output_file:
                output_file.write(result)

def main(domain, data, model, constraint_type, run_type, revision, default, problem_start, problem_end, constraint_start, constraint_end, solver):
    if default:
        problem_configs = parse_json_file(domain, data, constraint_type)
        problems = list(problem_configs.keys())
        constraints = [list(problem_configs[problem_name].keys())[0] for problem_name in problems]
    else:
        problems = ['p0' + str(problem_number) if problem_number < 10 else 'p' + str(problem_number) for problem_number in range(problem_start, problem_end)]
        constraints = [f'constraint{constraint_number}' for constraint_number in range(constraint_start, constraint_end)]
    
    run_solver_batch(domain, model, data, solver, run_type, constraint_type, revision, problems, constraints)

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
    problem_start = args.problem_start
    problem_end = args.problem_end
    constraint_start = args.constraint_start
    constraint_end = args.constraint_end
    main(domain=domain, data=data, model=model, constraint_type=constraint_type, run_type=run_type, revision=revision, default=default, problem_start=problem_start, problem_end=problem_end, constraint_start=constraint_start, constraint_end=constraint_end, solver=solver)
    