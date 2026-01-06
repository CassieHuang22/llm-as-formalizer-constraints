import os
import json
import argparse
import httpx
import asyncio
import time
import requests
from openai import OpenAI
from kani import Kani
from kani.engines.huggingface import HuggingEngine

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to evaluate", choices=["blocksworld", "mystery_blocksworld", "coin_collector"])
parser.add_argument("--data", help="which dataset to evaluate", choices=["BlocksWorld-100", "Mystery_BlocksWorld-100", "BlocksWorld-100-XL", "CoinCollector-100_includeDoors0"])
parser.add_argument("--model", help="which model to use", choices=["deepseek-reasoner", "deepseek-chat", "Qwen3-32B", "Qwen2.5-Coder-32B-Instruct"])
parser.add_argument("--run_type", help="which formalizer method to use", choices=["generate", "edit"])
parser.add_argument("--constraint_type", help="which constraint type to use", choices=["numerical", "sequential", "state-based", "goal", "initial", "baseline"])
parser.add_argument("--default", action="store_true")
parser.add_argument("--problems", type=str, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")
parser.add_argument("--constraints", type=str, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")
parser.add_argument("--solver", default="dual-bfws-ffparser")

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

async def revise_qwen(engine, domain_file, problem_file, error, model):
    prompt = "Respond only as shown."
    message = f"You are a PDDL expert. The following domain and problem files have the error: {error}\n\n{domain_file}\n{problem_file}\n\nRevise the PDDL to remove the error.\n"
    message = message + "Return a JSON object in the following format:\n{\n  \"domain file\": ...,\n  \"problem file\":...\n}"

    ai = Kani(engine, system_prompt=prompt)
    response = await ai.chat_round_str(message)
    print(response)
    start_index = response.find('{')
    end_index = response.find('}')
    json_string = response[start_index:end_index+1]
    output_dict = json.loads(json_string, strict=False)
    domain_file = output_dict["domain file"]
    problem_file = output_dict["problem file"]

    return domain_file, problem_file


def save_attempt(log_dir, example_id, domain_file, problem_file, status, attempt, run_type, constraint_type, output):
    problem, constraint, model = example_id.split("_")
    if status != "finished":
        attempt_dir = f"{log_dir}/logs/{run_type}/{model}/{constraint_type}/{problem}"
        domain_file_name = f"{example_id}_df_{attempt}.pddl"
        problem_file_name = f"{example_id}_pf_{attempt}.pddl"
        output_file_path = f"{attempt_dir}/{example_id}_error_{attempt}.txt"
        num_attempts_file = None
    else:
        attempt_dir = f"{log_dir}/{run_type}/{model}/{constraint_type}/{problem}"
        domain_file_name = f"{example_id}_df.pddl"
        problem_file_name = f"{example_id}_pf.pddl"
        num_attempts_file = f"{attempt_dir}/number_attempts.txt"
        output_file_path = f"{attempt_dir}/{example_id}_output_{attempt}.txt"
    os.makedirs(attempt_dir, exist_ok=True)

    # Write each output file
    domain_file_path = f"{attempt_dir}/{domain_file_name}"
    problem_file_path = f"{attempt_dir}/{problem_file_name}"
    with open(domain_file_path, 'w') as df:
        df.write(domain_file) 
    with open(problem_file_path, 'w') as pf:
        pf.write(problem_file)
    if num_attempts_file:
        with open(num_attempts_file, 'w') as file:
            file.write(str(attempt))
    with open(output_file_path, 'w') as output_file:
        output_file.write(output)

    return attempt_dir  

def run_solver(domain_file, problem_file, solver):
    req_body = {"domain" : domain_file, "problem" : problem_file}
    solve_request_url=requests.post(f"https://solver.planning.domains:5001/package/{solver}/solve", json=req_body).json()
    celery_result=requests.post('https://solver.planning.domains:5001' + solve_request_url['result'])
    while celery_result.json().get("status","")== 'PENDING':
        # Query the result every 0.5 seconds while the job is executing
        celery_result=requests.post('https://solver.planning.domains:5001' + solve_request_url['result'])
        time.sleep(0.5)
    if 'result' in celery_result.json().keys():
        output = celery_result.json()['result']
        if "plan" in output["output"] and output["output"]["plan"]:
            result = output["output"]["plan"]
            success = True
        elif output["stderr"]:
            result = output["stderr"]
            success = False
        else:
            result = output["stdout"]
            success = True if "Time Out" not in result else False
    else:
        result = celery_result.json()
        sucess = False
    return result, success


async def process_example_qwen(engine, domain, data, model, run_type, constraint_type, problem, constraint, log_dir, solver):
    success = False

    results_directory = f"../../../output/llm-as-pddl-formalizer/{domain}/{data}/{run_type}/{model}/{constraint_type}/{problem}"
    domain_file_path = f"{results_directory}/{problem}_{constraint}_{model}_df.pddl"
    problem_file_path = f"{results_directory}/{problem}_{constraint}_{model}_pf.pddl"
    error_file_path = f"{results_directory}/{problem}_{constraint}_{model}_error.txt"
    plan_file_path = f"{results_directory}/{problem}_{constraint}_{model}_plan.txt"
    output_path = f"{results_directory}/{problem}_{constraint}_{model}_output.txt"
    example_id = f"{problem}_{constraint}_{model}"
    domain_file = open(domain_file_path).read()
    problem_file = open(problem_file_path).read()

    malformed_attempt = 1
    max_malformed_attempts = 3
    solver_attempt = 1
    max_solver_attempts = 3
    output = ""
    if os.path.exists(error_file_path):
        output = open(error_file_path)
        while solver_attempt <= max_solver_attempts:
            while malformed_attempt <= max_malformed_attempts:
                try:
                    domain_file, problem_file = await revise_qwen(engine, domain_file, problem_file, output, model)
                    break
                except Exception as e:
                    print(e)
                    malformed_attempt += 1
            else:
                print(f"Could not produce well-formed output for problem {problem} / constraint {constraint} after {max_malformed_attempts} tries.")
                return
            connection_attempt = 1
            max_connection_attempts = 3
            while connection_attempt <= max_connection_attempts:
                try:
                    output, solver_success = run_solver(domain_file, problem_file, solver)
                    break
                except:
                    connection_attempt += 1
            else:
                print(f"Could not connect to solver for problem {problem} / constraint {constraint} after {max_connection_attempts} tries.")

            if solver_success:
                save_attempt(log_dir, example_id, domain_file, problem_file, "finished", solver_attempt, run_type, constraint_type, output)
                success = True
                break
            else:
                attempt_dir = save_attempt(log_dir, example_id, domain_file, problem_file, "solver_error", solver_attempt, run_type, constraint_type, output)
            solver_attempt += 1
    else:
        if not os.path.exists(plan_file_path) and not os.path.exists(output_path):
            raise Exception("run solver first, then perform revision")
        else:
            save_attempt(log_dir, example_id, domain_file, problem_file, "finished", 0, run_type, constraint_type, output)
            success = True

    if not success:
        save_attempt(log_dir, example_id, domain_file, problem_file, "finished", solver_attempt, run_type, constraint_type, output)

async def run_pipeline_qwen(engine, domain, data, model, run_type, constraint_type, problems, constraints, solver):
    log_dir = f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/revisions'

    for problem, constraint in zip(problems, constraints):
        await process_example_qwen(engine, domain, data, model, run_type, constraint_type, problem, constraint, log_dir, solver)

def main(domain, data, model, run_type, constraint_type, default, problems, constraints, solver):
    if default:
        problem_names, constraint_names = get_default(domain, data, constraint_type)
    else:
        problem_names, constraint_names = problem_and_constraint_names(problems, constraints)

    engine = HuggingEngine(model_id = f"Qwen/{model}", model_load_kwargs={"device_map": "auto"})
    asyncio.run(run_pipeline_qwen(engine, domain, data, model, run_type, constraint_type, problem_names, constraint_names, solver))
    

if __name__ == "__main__":
    args = parser.parse_args()
    domain = args.domain
    data = args.data
    model = args.model
    run_type = args.run_type
    constraint_type = args.constraint_type
    default = args.default
    problems = args.problems
    constraints = args.constraints
    solver = args.solver
    main(domain, data, model, run_type, constraint_type, default, problems, constraints, solver)
