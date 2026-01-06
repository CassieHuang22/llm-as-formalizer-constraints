import argparse
import json
import subprocess
import os

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to use")
parser.add_argument("--data", help="which dataset to use")
parser.add_argument("--constraint_type", choices=["baseline", "action", "state", "initial", "goal", "original"])
parser.add_argument("--model", help="which model to evaluate")
parser.add_argument("--run_type", help="type of output for the model", choices=["generate", "edit"])
parser.add_argument("--revision", action='store_true')
parser.add_argument("--attempt", type=int, help="which attempt to compile")
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

def run_compiler(domain, data, problem, constraint, model, run_type, constraint_type, revision, attempt):
    mode = "revisions/" if revision else ""
    attempt_dir = f"attempt{attempt}/" if attempt else ""
    if constraint_type != "original":
        domain_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{constraint}_{model}_df.pddl'
        problem_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{constraint}_{model}_pf.pddl'

        compiled_result_folder = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{constraint}_{model}_compiled_result'
    else:
        domain_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{model}_df.pddl'
        problem_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{model}_pf.pddl'

        compiled_result_folder = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{model}_compiled_result'

    tcore_executable = '../../../../tcore/launch_tcore.py'
    command = ['python', tcore_executable, domain_file_path, problem_file_path, compiled_result_folder]
    try:
        subprocess.run(command, capture_output=True, text=True, check=True, timeout=60)
        
    except Exception as e:
        return f"Error:\n{e.stderr}"
    
def run_compiler_batch(domain, model, data, run_type, constraint_type, revision, attempt, problems, constraints):
    print(f"Run compiler on {domain}_{data}_{model}_{run_type}_{constraint_type}")
    for problem, constraint in zip(problems, constraints):
        print(f'Running {problem}_{constraint}')
        mode = "revisions/" if revision else ""
        attempt_dir = f"attempt{attempt}/" if attempt else ""
        if constraint_type != "original":
            error_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{constraint}_{model}_error.txt'
        else:
            error_file_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{mode}{run_type}/{model}/{constraint_type}/{attempt_dir}{problem}/{problem}_{model}_error.txt'
        if os.path.exists(error_file_path):
            continue
        try:
            output = run_compiler(domain, data, problem, constraint, model, run_type, constraint_type, revision, attempt)       
            if output and "Error" in output:
                with open(error_file_path, 'w') as error_file:
                    error_file.write(output)
        except Exception as e:
                raise
        
def main(domain, data, model, constraint_type, run_type, revision, attempt, default, problems, constraints):
    if default:
        problem_names, constraint_names = get_default(domain, data, constraint_type)
    else:
        problem_names, constraint_names = problem_and_constraint_names(problems, constraints)
    
    run_compiler_batch(domain, model, data, run_type, constraint_type, revision, attempt, problem_names, constraint_names)

if __name__=="__main__":
    args = parser.parse_args()
    domain = args.domain
    data = args.data
    model = args.model
    constraint_type = args.constraint_type
    run_type = args.run_type
    revision = args.revision
    attempt = args.attempt
    default = args.default
    problems = args.problems
    constraints = args.constraints
    main(domain=domain, data=data, model=model, constraint_type=constraint_type, run_type=run_type, revision=revision, attempt=attempt, default=default, problems=problems, constraints=constraints)