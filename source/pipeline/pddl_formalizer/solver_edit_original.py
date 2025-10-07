import requests
import time
import pandas as pd
import os
import json
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to use")
parser.add_argument("--data", help="which dataset to use")
parser.add_argument("--model", help="which model to evaluate")
parser.add_argument("--solver", default="dual-bfws-ffparser")
parser.add_argument("--default", action='store_true')
parser.add_argument("--problem_start", type=int)
parser.add_argument("--problem_end", type=int)
args = parser.parse_args()

def run_solver(domain, data, problem, model, solver):
    domain_file = open(f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_df.pddl').read()
    problem_file = open(f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_pf.pddl').read()


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

def run_solver_batch(domain, model, data, solver, problems):
    attempts = 3
    for problem in problems:
        print(f"Running {problem}")
        for i in range(attempts):
            try:
                output = run_solver(domain, data, problem, model, solver)               
            except Exception as e:
                print(e)
                if i < attempts - 1:
                    continue
                else:
                    raise
            break
        
        
        if output["output"]["plan"]:
            output_path = f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_plan.txt'
            result = output["output"]["plan"]
        elif output["stderr"]:
            output_path = f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_error.txt'
            result = output["stderr"]
        else:
            output_path = f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_output.txt'
            result = output["stdout"]

        if not os.path.exists(os.path.dirname(output_path)):
            os.makedirs(os.path.dirname(output_path))

        with open(output_path, 'w') as output_file:
                output_file.write(result)

def main(domain, data, model, default, problem_start, problem_end, solver):
    if default:
        all_problems = ['p0' + str(problem_number) if problem_number < 10 else 'p' + str(problem_number) for problem_number in range(1, 101)]
    else:
        all_problems = ['p0' + str(problem_number) if problem_number < 10 else 'p' + str(problem_number) for problem_number in range(problem_start, problem_end)]
    all_removed_problems = {'blocksworld': ['p58', 'p59', 'p60'], 'coin_collector': ['p43', 'p47', 'p48', 'p51', 'p52', 'p55', 'p56', 'p60'], 'mystery_blocksworld': ['p58', 'p59', 'p60']}
    removed_problems = all_removed_problems[domain]
    problems = [problem for problem in all_problems if problem not in removed_problems]
    
    run_solver_batch(domain, model, data, solver, problems)

if __name__=="__main__":
    args = parser.parse_args()
    domain = args.domain
    data = args.data
    model = args.model
    solver = args.solver
    default = args.default
    problem_start = args.problem_start
    problem_end = args.problem_end
    main(domain=domain, data=data, model=model, default=default, problem_start=problem_start, problem_end=problem_end, solver=solver)
    