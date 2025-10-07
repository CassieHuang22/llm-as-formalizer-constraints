import requests
import time
import pandas as pd
import os
import json
import argparse
import subprocess
import re

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to use")
parser.add_argument("--data", help="which dataset to use")
parser.add_argument("--model", help="which model to evaluate")
parser.add_argument("--default", action='store_true')
parser.add_argument("--problem_start", type=int)
parser.add_argument("--problem_end", type=int)
args = parser.parse_args()

def is_valid_plan(output: str):
    """
    Check if stdout contains a valid plan.
    Returns:
      (True, [list of actions]) if valid
      (False, original_output) if not valid
    """
    output = output.replace("\"", "")
    # Flexible regex: (ACTION arg1 arg2 ...)
    action_pattern = re.compile(r'^\([A-Za-z_-]+( [A-Za-z0-9_-]+)+\)$')
    text = output.strip()
    lines = text.splitlines()
    plan_lines = []

    # Case A: plan wrapped in a list [(), (), ...]
    if text.startswith("[") and text.endswith("]"):
        content = text[1:-1]   # remove [ ]
        raw_items = [x.strip() for x in content.split(",")]
        for item in raw_items:
            if item and action_pattern.match(item):
                plan_lines.append(item)
        if plan_lines:
            return True, plan_lines
        return False, output

    # Case B: scan lines until we see first valid action
    found_plan = False
    for line in lines:
        line = line.strip()
        if action_pattern.match(line):
            found_plan = True
            plan_lines.append(line)
        elif found_plan:
            # stop at first invalid after plan starts
            break

    if plan_lines:
        return True, plan_lines
    elif output == '':
        return True, ''
    else:
        return False, output

def run_solver(domain, data, problem, model):
    python_file = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}.py'
    output = {}
    try:
        result = subprocess.run(["python", python_file], capture_output=True, text=True, timeout=120)
        output["return_code"] = result.returncode
        output["stdout"] = result.stdout
        output["stderr"] = result.stderr
    except subprocess.TimeoutExpired:
        output["exception"] = "Time out"
    except Exception as e:
        output["exception"] = str(e)
    return output

def run_solver_batch(domain, model, data, problems):
    for problem in problems:
        print(f"Running {problem}")
        solver_output = run_solver(domain, data, problem, model)               

        if "exception" in solver_output:
            if "Time out" in solver_output["exception"]:
                output_path = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_output.txt'
                result = solver_output["exception"]
            else:
                output_path = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_error.txt'
                result = solver_output["exception"]
        elif solver_output["stderr"]:
            output_path = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_error.txt'
            result = solver_output["stderr"]
        else:
            output = solver_output["stdout"]
            plan_valid, plan = is_valid_plan(output)
            if plan_valid:
                output_path = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_plan.txt'
                result = "\n".join(plan)
            else:
                output_path = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_output.txt'
                result = output
        if not os.path.exists(os.path.dirname(output_path)):
            os.makedirs(os.path.dirname(output_path))

        with open(output_path, 'w') as output_file:
                output_file.write(result)

def main(domain, data, model, default, problem_start, problem_end):
    if default:
        all_problems = ['p0' + str(problem_number) if problem_number < 10 else 'p' + str(problem_number) for problem_number in range(1, 101)]
    else:
        all_problems = ['p0' + str(problem_number) if problem_number < 10 else 'p' + str(problem_number) for problem_number in range(problem_start, problem_end)]
    all_removed_problems = {'blocksworld': ['p58', 'p59', 'p60'], 'coin_collector': ['p43', 'p47', 'p48', 'p51', 'p52', 'p55', 'p56', 'p60'], 'mystery_blocksworld': ['p58', 'p59', 'p60']}
    removed_problems = all_removed_problems[domain]
    problems = [problem for problem in all_problems if problem not in removed_problems]
    
    run_solver_batch(domain, model, data, problems)

if __name__=="__main__":
    args = parser.parse_args()
    domain = args.domain
    data = args.data
    model = args.model
    default = args.default
    problem_start = args.problem_start
    problem_end = args.problem_end
    main(domain=domain, data=data, model=model, default=default, problem_start=problem_start, problem_end=problem_end)
    