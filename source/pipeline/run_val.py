import re
import subprocess
import json
import os
import argparse
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to use")
parser.add_argument("--data", help="which dataset to use")
parser.add_argument("--constraint_type", choices=["baseline", "action", "state", "initial", "goal"])
parser.add_argument("--model", help="which model to evaluate")
parser.add_argument("--prediction_type")
parser.add_argument("--run_type")
parser.add_argument("--revision", action='store_true')
parser.add_argument("--py2pddl", action='store_true')
parser.add_argument("--csv_result", help="get full output as csv file", action='store_true')
parser.add_argument("--formalizing_type", help="which formal language to evaluate")
args = parser.parse_args()

def parse_json_file(domain, data, constraint_type):
    jsonl_file_path = f'../../data/{domain}/{data}/constraints/{constraint_type}/pddl/groundtruth_plan_info.jsonl'
    problem_configs = {}
    descriptions = []
    with open(jsonl_file_path) as jsonl_file:
        for line in jsonl_file:
            groundtruth_plan_info = json.loads(line)
            
            problem_name = groundtruth_plan_info["problem"]
            constraint_name = groundtruth_plan_info["constraint"]
            plan_exists = groundtruth_plan_info["plan_exists"]
            constraint_description = groundtruth_plan_info["constraint_description"]
            problem_configs.setdefault(problem_name, {})[constraint_name] = plan_exists
            descriptions.append(constraint_description)
    
    return problem_configs, descriptions

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
    
def validate_plan_batch(domain, data, model, prediction_type, csv_result, constraint_type, run_type, revision, py2pddl, formalizing_type):
    problem_names = []
    constraint_names = []
    constraint_types = []
    errors = []
    plans = []
    plan_exists = []
    val_results = []
    is_plan_correct = []
    syntax_errors = 0
    correctness = 0

    if formalizing_type == 'ltl' and constraint_type == 'baseline':
        groundtruth_plan_exists, constraint_descriptions = parse_json_file(domain, data, constraint_type)
        problem_numbers = [3,4,7,8,12,16,20,58,1,2,5,6,9,10,11,13,14,15,17,18,19,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,44,45,46,49,50,53,54,57,59] + list(range(61, 81))
        problems = [f'p0{problem_number}' if problem_number < 10 else f'p{problem_number}' for problem_number in problem_numbers]
        constraints = [f'constraint{problem_number}' for problem_number in problem_numbers]
    else:
        groundtruth_plan_exists, constraint_descriptions = parse_json_file(domain, data, constraint_type)
        problems = list(groundtruth_plan_exists.keys())
        constraints = [list(groundtruth_plan_exists[problem_name].keys())[0] for problem_name in problems]

    for problem_name, constraint_name in zip(problems, constraints):
        does_plan_exist = groundtruth_plan_exists[problem_name][constraint_name]

        print(f"Running {problem_name}_{constraint_name}")
        problem_names.append(problem_name)
        constraint_names.append(constraint_name)
        constraint_types.append(constraint_type)
        plan_exists.append(does_plan_exist)
        if prediction_type == "llm-as-formalizer":
            mode = "revisions/" if revision else "py2pddl/" if py2pddl else ""
            error_file = f'../../output/llm-as-{formalizing_type}-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem_name}/{problem_name}_{constraint_name}_{model}_error.txt'
            plan_file = f'../../output/llm-as-{formalizing_type}-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem_name}/{problem_name}_{constraint_name}_{model}_plan.txt'
            output_file = f'../../output/llm-as-{formalizing_type}-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem_name}/{problem_name}_{constraint_name}_{model}_output.txt'
            if os.path.exists(error_file):
                error = open(error_file).read()
                errors.append(error)
                plans.append('')
                val_results.append('')
                is_plan_correct.append('')
                syntax_errors += 1
            elif os.path.exists(plan_file):
                plan = open(plan_file).read()
                if not does_plan_exist:
                    errors.append('')
                    plans.append(plan)
                    val_results.append('')
                    is_plan_correct.append('plan does not exist')
                else:
                    new_plan_file = f'../../output/llm-as-{formalizing_type}-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem_name}/{problem_name}_{constraint_name}_{model}_plan_VAL.txt'
                    standard_plan, _ = plan_to_path(domain, plan, new_plan_file)
                    plans.append(standard_plan)
                    errors.append('')
                    domain_file = f'../../data/{domain}/{data}/constraints/{constraint_type}/pddl/{problem_name}/{problem_name}_{constraint_name}_df.pddl'
                    problem_file = f'../../data/{domain}/{data}/constraints/{constraint_type}/pddl/{problem_name}/{problem_name}_{constraint_name}_pf.pddl'
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
                    new_plan_file = f'../../output/llm-as-{formalizing_type}-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{problem_name}/{problem_name}_{constraint_name}_{model}_plan_VAL.txt'
                    standard_plan, _ = plan_to_path(domain, plan, new_plan_file)
                    plans.append(standard_plan)
                    errors.append('')
                    domain_file = f'../../data/{domain}/{data}/constraints/{constraint_type}/pddl/{problem_name}/{problem_name}_{constraint_name}_df.pddl'
                    problem_file = f'../../data/{domain}/{data}/constraints/{constraint_type}/pddl/{problem_name}/{problem_name}_{constraint_name}_pf.pddl'
                    val_result = validate_plan(domain_file, problem_file, new_plan_file)
                    val_results.append(val_result)

                    if "Error" in val_result or "Failed" in val_result:
                        is_plan_correct.append("no")
                    else:
                        is_plan_correct.append("yes")
                        correctness += 1
                elif "NOTFOUND" in output or "No plan" in output or "no solution" in output.lower() or "no plan" in output.lower() or "cannot generate plan" in output:
                    if not does_plan_exist:
                        errors.append('')
                        plans.append(output)
                        val_results.append('')
                        is_plan_correct.append('plan does not exist')
                        correctness += 1
                    else:
                        if formalizing_type == 'ltl':
                            syntax_errors += 1
                        errors.append('')
                        plans.append(output)
                        val_results.append('')
                        is_plan_correct.append('plan not found but exists')

                else:
                    errors.append(output)
                    plans.append('')
                    val_results.append('')
                    is_plan_correct.append('no')
        else:
            plan_file = f'../../output/llm-as-planner/{domain}/{data}/{model}/{constraint_type}/{problem_name}/{problem_name}_{constraint_name}_{model}_plan.txt'
            plan = open(plan_file).read()
            if not does_plan_exist:
                if not plan:
                    errors.append('')
                    plans.append(plan)
                    val_results.append('')
                    is_plan_correct.append("yes")
                    correctness += 1
                else:
                    errors.append('')
                    plans.append(plan)
                    val_results.append('')
                    is_plan_correct.append('plan does not exist')
            else:
                new_plan_file = f'../../output/llm-as-planner/{domain}/{data}/{model}/{constraint_type}/{problem_name}/{problem_name}_{constraint_name}_{model}_plan_VAL.txt'
                standard_plan, _ = plan_to_path(domain, plan, new_plan_file)
                plans.append(standard_plan)
                errors.append('')
                domain_file = f'../../data/{domain}/{data}/constraints/{constraint_type}/pddl/{problem_name}/{problem_name}_{constraint_name}_df.pddl'
                problem_file = f'../../data/{domain}/{data}/constraints/{constraint_type}/pddl/{problem_name}/{problem_name}_{constraint_name}_pf.pddl'
                val_result = validate_plan(domain_file, problem_file, new_plan_file)
                val_results.append(val_result)

                if "Error" in val_result or "Failed" in val_result:
                    is_plan_correct.append("no")
                else:
                    is_plan_correct.append("yes")
                    correctness += 1
            

    if csv_result:
        all_results_dict = {
            "problem_number": problem_names,
            "constraint_type": constraint_types,
            "constraint_number": constraint_names,
            "constraint_description": constraint_descriptions,
            "does_plan_exist": plan_exists,
            "error": errors,
            "plan": plans,
            "val_result": val_results,
            "is_plan_correct": is_plan_correct
        }

        all_results = pd.DataFrame(all_results_dict)
        run_type_directory = f"{run_type}/" if run_type else ""
        run_type_string = f"{run_type}_" if run_type else ''
        mode_directory = "revisions/" if revision else "py2pddl/" if py2pddl else ""
        mode_string = "revision_" if revision else "py2pddl_" if py2pddl else ""
        method = f"llm-as-{formalizing_type}-formalizer" if prediction_type == "llm-as-formalizer" else "llm-as-planner"
        result_path = f'../../output/{method}/{domain}/{data}/{mode_directory}{run_type_directory}{model}/{method}_{run_type_string}{mode_string}{constraint_type}_{domain}_{data}_{model}_results.csv'
        print(result_path)
        all_results.to_csv(result_path)

    print(f"Syntax Errors: {syntax_errors if prediction_type == 'llm-as-formalizer' else '---'}/{len(problems)}")
    print(f"Correctness: {correctness}/{len(problems)}")


validate_plan_batch(domain=args.domain, data=args.data, model=args.model, prediction_type=args.prediction_type, csv_result=args.csv_result, constraint_type=args.constraint_type, run_type=args.run_type, revision=args.revision, py2pddl=args.py2pddl, formalizing_type=args.formalizing_type)