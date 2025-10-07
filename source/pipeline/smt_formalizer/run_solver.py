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
parser.add_argument("--constraint_type", choices=["baseline", "initial", "goal", "action", "state"])
parser.add_argument("--model", help="which model to evaluate")
parser.add_argument("--run_type", help="type of output for the model", choices=["generate", "edit"])
parser.add_argument("--revision", action='store_true')
parser.add_argument("--problems", type=str, required=True, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")
parser.add_argument("--constraints", type=str, required=True, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")
args = parser.parse_args()

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


def run_solver(domain, data, problem, constraint, model, run_type, constraint_type, revision):
    mode = "revisions/" if revision else ""
    python_file = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}.py'
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
    

def run_solver_batch(domain, model, data, run_type, constraint_type, revision, problems, constraints):
    for problem, constraint in zip(problems, constraints):
        print(f"Running {problem}_{constraint}")
        solver_output = run_solver(domain, data, problem, constraint, model, run_type, constraint_type, revision)               
        
        mode = "revisions/" if revision else ""
        if "exception" in solver_output:
            if "Time out" in solver_output["exception"]:
                output_path = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_output.txt'
                result = solver_output["exception"]
            else:
                output_path = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_error.txt'
                result = solver_output["exception"]
        elif solver_output["stderr"]:
            output_path = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_error.txt'
            result = solver_output["stderr"]
        else:
            output = solver_output["stdout"]
            plan_valid, plan = is_valid_plan(output)
            if plan_valid:
                output_path = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_plan.txt'
                result = "\n".join(plan)
            else:
                output_path = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_output.txt'
                result = output
        if not os.path.exists(os.path.dirname(output_path)):
            os.makedirs(os.path.dirname(output_path))

        with open(output_path, 'w') as output_file:
                output_file.write(result)

def main(domain, data, model, constraint_type, run_type, revision, problems, constraints):
    problem_names, constraint_names = problem_and_constraint_names(problems, constraints)
    
    run_solver_batch(domain, model, data, run_type, constraint_type, revision, problem_names, constraint_names)

if __name__=="__main__":
    args = parser.parse_args()
    domain = args.domain
    data = args.data
    model = args.model
    constraint_type = args.constraint_type
    run_type = args.run_type
    revision = args.revision
    problems = args.problems
    constraints = args.constraints
    main(domain=domain, data=data, model=model, constraint_type=constraint_type, run_type=run_type, revision=revision, problems=problems, constraints=constraints)
    