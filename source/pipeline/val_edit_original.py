import re
import subprocess
import json
import os
import argparse
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to use")
parser.add_argument("--data", help="which dataset to use")
parser.add_argument("--model", help="which model to evaluate")
parser.add_argument("--revision", action='store_true')
parser.add_argument("--py2pddl", action='store_true')
parser.add_argument("--formalizing_type")
parser.add_argument("--csv_result", help="get full output as csv file", action='store_true')
args = parser.parse_args()

def standardize_blocks(plan):
    new_plan = re.sub(
        r'\b(?:b|block)?\s*(\d+)\b',
        lambda m: f' block{m.group(1)}',
        plan,
        flags=re.IGNORECASE
    )
    # Remove any double spaces that may be left over
    new_plan = re.sub(r'\s{2,}', ' ', new_plan)
    return new_plan.strip()

def plan_to_path(domain, plan, plan_filepath):
    plan = plan.strip().lower().replace('-', '')
    if domain == "blocksworld":
        plan = standardize_blocks(plan)
    with open(plan_filepath, 'w') as plan_file:
        plan_file.write(plan)

    return plan, plan_filepath

def validate_plan(domain_file_path, problem_file_path, plan_filepath):
    validate_executable = "../../../../../Research/PDDL_Project/VAL/build/macos64/Release/bin/Validate"
    
    command = [validate_executable, "-v", domain_file_path, problem_file_path, plan_filepath]
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True)
        return f"Validation Output:\n{result.stdout}"
        
    except subprocess.CalledProcessError as e:
        return f"Error:\n{e.output}"
    
def validate_plan_batch(domain, data, model, csv_result, revision, py2pddl, formalizing_type):
    problem_names = []
    errors = []
    plans = []
    val_results = []
    is_plan_correct = []
    syntax_errors = 0
    correctness = 0

    problems = ['p0' + str(problem_number) if problem_number < 10 else 'p' + str(problem_number) for problem_number in range(1, 101)]
    all_removed_problems = {'blocksworld': ['p58', 'p59', 'p60'], 'coin_collector': ['p43', 'p47', 'p48', 'p51', 'p52', 'p55', 'p56', 'p60'], 'mystery_blocksworld': ['p58', 'p59', 'p60']}
    removed_problems = all_removed_problems[domain]

    for problem_name in problems:

        if problem_name in removed_problems:
            continue

        print(f"Running {problem_name}")
        problem_names.append(problem_name)
        
        mode = "revisions/" if revision else "py2pddl/" if py2pddl else ""
        error_file = f'../../output/llm-as-{formalizing_type}-formalizer/{domain}/{data}/{mode}edit/{model}/original/{problem_name}/{problem_name}_{model}_error.txt'
        plan_file = f'../../output/llm-as-{formalizing_type}-formalizer/{domain}/{data}/{mode}edit/{model}/original/{problem_name}/{problem_name}_{model}_plan.txt'
        output_file = f'../../output/llm-as-{formalizing_type}-formalizer/{domain}/{data}/{mode}edit/{model}/original/{problem_name}/{problem_name}_{model}_output.txt'
        if os.path.exists(error_file):
            error = open(error_file).read()
            errors.append(error)
            plans.append('')
            val_results.append('')
            is_plan_correct.append('')
            syntax_errors += 1
        elif os.path.exists(plan_file):
            plan = open(plan_file).read()

            new_plan_file = f'../../output/llm-as-{formalizing_type}-formalizer/{domain}/{data}/{mode}edit/{model}/original/{problem_name}/{problem_name}_{model}_plan_VAL.txt'
            standard_plan, _ = plan_to_path(domain, plan, new_plan_file)
            plans.append(standard_plan)
            errors.append('')
            domain_file = f'../../data/{domain}/{data}/pddl/domain.pddl'
            problem_file = f'../../data/{domain}/{data}/pddl/{problem_name}.pddl'
            val_result = validate_plan(domain_file, problem_file, new_plan_file)
            val_results.append(val_result)

            if "Error" in val_result or "Failed" in val_result:
                is_plan_correct.append("no")
            else:
                is_plan_correct.append("yes")
                correctness += 1
        else:
            output = open(output_file).read()
            if "Plan found with cost: 0" in output or "The empty plan solves it" in output:
                plan = ""
                new_plan_file = f'../../output/llm-as-{formalizing_type}-formalizer/{domain}/{data}/{mode}edit/{model}/original/{problem_name}/{problem_name}_{model}_plan_VAL.txt'
                standard_plan, _ = plan_to_path(domain, plan, new_plan_file)
                plans.append(standard_plan)
                errors.append('')
                domain_file = f'../../data/{domain}/{data}/pddl/domain.pddl'
                problem_file = f'../../data/{domain}/{data}/pddl/{problem_name}.pddl'
                val_result = validate_plan(domain_file, problem_file, new_plan_file)
                val_results.append(val_result)

                if "Error" in val_result or "Failed" in val_result:
                    is_plan_correct.append("no")
                else:
                    is_plan_correct.append("yes")
                    correctness += 1
            elif "NOTFOUND" in output or "No plan" in output or "no solution" in output.lower() or "no plan" in output.lower():
                errors.append('')
                plans.append(output)
                val_results.append('')
                is_plan_correct.append('plan not found but exists')
            else:
                errors.append(output)
                plans.append('')
                val_results.append('')
                is_plan_correct.append('no')
            

    if csv_result:
        all_results_dict = {
            "problem_number": problem_names,
            "error": errors,
            "plan": plans,
            "val_result": val_results,
            "is_plan_correct": is_plan_correct
        }

        all_results = pd.DataFrame(all_results_dict)
        mode_directory = "revisions/" if revision else "py2pddl/" if py2pddl else ""
        mode_string = "revision_" if revision else "py2pddl_" if py2pddl else ""
        result_path = f'../../output/llm-as-{formalizing_type}-formalizer/{domain}/{data}/{mode_directory}edit/{model}/llm-as-{formalizing_type}-formalizer_edit_{mode_string}_{domain}_{data}_{model}_results.csv'
        print(result_path)
        all_results.to_csv(result_path)

    print(f"Syntax Errors: {syntax_errors}/{len(problems)-len(removed_problems)}")
    print(f"Correctness: {correctness}/{len(problems)-len(removed_problems)}")


validate_plan_batch(domain=args.domain, data=args.data, model=args.model, csv_result=args.csv_result, revision=args.revision, py2pddl=args.py2pddl, formalizing_type=args.formalizing_type)