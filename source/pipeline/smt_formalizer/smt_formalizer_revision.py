import os
import json
import requests
import time
import argparse
from openai import OpenAI
import subprocess
import asyncio
from kani import Kani
from kani.engines.huggingface import HuggingEngine
import re

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to evaluate", choices=["blocksworld", "mystery_blocksworld", "coin_collector"])
parser.add_argument("--data", help="which dataset to evaluate", choices=["BlocksWorld-100", "Mystery_BlocksWorld-100", "BlocksWorld-100-XL", "CoinCollector-100_includeDoors0"])
parser.add_argument("--model", help="which model to use", choices=["deepseek-reasoner", "deepseek-chat", "Qwen3-32B", "Qwen2.5-Coder-32B-Instruct"])
parser.add_argument("--run_type", help="which formalizer method to use", choices=["generate", "edit"])
parser.add_argument("--constraint_type", help="which constraint type to use", choices=["numerical", "sequential", "state-based", "goal", "initial", "baseline"])
parser.add_argument("--default", action="store_true")
parser.add_argument("--problems", type=str, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")
parser.add_argument("--constraints", type=str, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")

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

def extract_code(text):
    match = re.search( r"```python(.*?)```", text, re.DOTALL)
    if match:
        return match.group(1).strip()
    return None


def revise_deepseek(client, python_file, error, model):
    prompt = f"You are a Z3 expert. The following domain and problem files have the error: {error}\n\n{python_file}\n\nRevise the Z3 code to remove the error.\n"
    output_format = """Your final answer must be a complete, runnable Z3 Python script enclosed within triple backticks, like this:
```python
# Your Z3 code here
from z3 import *
...
```"""
    message = prompt + "Return a JSON object in the following format:\n{\n  \"code\": ...\n}"

    completion = client.chat.completions.create(
        model=model,
        messages=[
        {"role": "user", "content": message}
        ],
        response_format = {"type": "json_object"}
    )

    result = completion.choices[0].message.content
    print(result)
    output_json = json.loads(result, strict=False)
    python_file = output_json["code"]
    return python_file

async def revise_qwen(engine, python_file, error):
    prompt = "Respond only as shown."
    output_format = """Your final answer must be a complete, runnable Z3 Python script enclosed within triple backticks, like this:
```python
# Your Z3 code here
from z3 import *
...
```"""
    message = f"You are a Z3 expert. The following domain and problem files have the error: {error}\n\n{python_file}\n\nRevise the Z3 code to remove the error.\n"
    message += f"\n{output_format}"

    ai = Kani(engine, system_prompt=prompt)
    response = await ai.chat_round_str(message)
    python_code = extract_code(response)

    return python_code


def save_attempt(log_dir, example_id, python_file, attempt, run_type, constraint_type):
    problem, constraint, model = example_id.split("_")

    attempt_dir = f"{log_dir}/{run_type}/{model}/{constraint_type}/{problem}"
    python_file_name = f"{example_id}.py"
    num_attempts_file = f"{attempt_dir}/number_attempts.txt"
    os.makedirs(attempt_dir, exist_ok=True)

    # Write each output file
    python_file_path = f"{attempt_dir}/{python_file_name}"
    with open(python_file_path, 'w') as file:
        if python_file:
            file.write(python_file)
        else:
            file.write('')
    with open(num_attempts_file, 'w') as file:
        file.write(str(attempt))

    return attempt_dir  

def run_solver(log_dir, python_file, num_attempt, example_id, run_type, constraint_type):
    problem, constraint, model = example_id.split("_")
    attempt_dir = f"{log_dir}/logs/{run_type}/{model}/{constraint_type}/{problem}"
    revised_python_file_name = f'{example_id}_{num_attempt}.py'
    python_file_path = f'{attempt_dir}/{revised_python_file_name}'
    if not os.path.exists(os.path.dirname(python_file_path)):
        os.makedirs(os.path.dirname(python_file_path))

    with open(python_file_path, 'w') as revised_python_file:
        if python_file:
            revised_python_file.write(python_file)
        else:
            revised_python_file.write('')

    output = {}
    try:
        result = subprocess.run(["python", python_file_path], capture_output=True, text=True, timeout=120)
        output["return_code"] = result.returncode
        output["stdout"] = result.stdout
        output["stderr"] = result.stderr
    except subprocess.TimeoutExpired:
        output["exception"] = "Time out"
    except Exception as e:
        output["exception"] = str(e)

    if "exception" in output:
        if "Time out" in output["exception"]:
            returned_output = output["exception"]
            solver_sucess = True
        else:
            returned_output = output["exception"]
            solver_sucess = False
    elif output["stderr"]:
        returned_output = output["stderr"]
        solver_sucess = False
    else:
        returned_output = output["stdout"]
        solver_sucess = True
    revised_output_file_name = f'{example_id}_{num_attempt}.txt'
    revised_output_file_path = f'{attempt_dir}/{revised_output_file_name}'
    with open(revised_output_file_path, 'w') as revised_output_file:
        revised_output_file.write(returned_output)
    return returned_output, solver_sucess

def process_example_deepseek(client, domain, data, model, run_type, constraint_type, problem, constraint, log_dir):
    success = False

    results_directory = f"../../../output/llm-as-smt-formalizer/{domain}/{data}/{run_type}/{model}/{constraint_type}/{problem}"
    python_file_path = f"{results_directory}/{problem}_{constraint}_{model}.py"
    error_file_path = f"{results_directory}/{problem}_{constraint}_{model}_error.txt"
    plan_file_path = f"{results_directory}/{problem}_{constraint}_{model}_plan.txt"
    output_path = f"{results_directory}/{problem}_{constraint}_{model}_output.txt"
    example_id = f"{problem}_{constraint}_{model}"
    python_file = open(python_file_path).read()

    max_malformed_attempts = 3
    max_solver_attempts = 3
    solver_attempt = 1
    output = ""
    if os.path.exists(error_file_path):
        output = open(error_file_path).read()
        while solver_attempt <= max_solver_attempts:
            malformed_attempt = 1
            while malformed_attempt <= max_malformed_attempts:
                try:
                    python_file = revise_deepseek(client, python_file, output, model)
                    break
                except Exception as e:
                    print(e)
                    malformed_attempt += 1
            else:
                print(f"Could not produce well-formed output for problem {problem} / constraint {constraint} after {max_malformed_attempts} tries.")
                return
            output, solver_success = run_solver(log_dir, python_file, solver_attempt, example_id, run_type, constraint_type)

            if solver_success:
                save_attempt(log_dir, example_id, python_file, solver_attempt, run_type, constraint_type)
                success = True
                break
            solver_attempt += 1
    else:
        if not os.path.exists(plan_file_path) and not os.path.exists(output_path):
            raise Exception("run solver first, then perform revision")
        else:
            save_attempt(log_dir, example_id, python_file, 0, run_type, constraint_type)
            success = True

    if not success:
        save_attempt(log_dir, example_id, python_file, solver_attempt, run_type, constraint_type)

async def process_example_qwen(engine, domain, data, model, run_type, constraint_type, problem, constraint, log_dir):
    success = False

    results_directory = f"../../../output/llm-as-smt-formalizer/{domain}/{data}/{run_type}/{model}/{constraint_type}/{problem}"
    python_file_path = f"{results_directory}/{problem}_{constraint}_{model}.py"
    error_file_path = f"{results_directory}/{problem}_{constraint}_{model}_error.txt"
    plan_file_path = f"{results_directory}/{problem}_{constraint}_{model}_plan.txt"
    output_path = f"{results_directory}/{problem}_{constraint}_{model}_output.txt"
    example_id = f"{problem}_{constraint}_{model}"
    python_file = open(python_file_path).read()

    max_malformed_attempts = 3
    max_solver_attempts = 3
    solver_attempt = 1
    output = ""
    if os.path.exists(error_file_path):
        output = open(error_file_path).read()
        while solver_attempt <= max_solver_attempts:
            malformed_attempt = 1
            while malformed_attempt <= max_malformed_attempts:
                try:
                    python_file = await revise_qwen(engine, python_file, output)
                    break
                except Exception as e:
                    print(e)
                    malformed_attempt += 1
            else:
                print(f"Could not produce well-formed output for problem {problem} / constraint {constraint} after {max_malformed_attempts} tries.")
                return
            output, solver_success = run_solver(log_dir, python_file, solver_attempt, example_id, run_type, constraint_type)

            if solver_success:
                save_attempt(log_dir, example_id, python_file, solver_attempt, run_type, constraint_type)
                success = True
                break
            solver_attempt += 1
    else:
        if not os.path.exists(plan_file_path) and not os.path.exists(output_path):
            raise Exception("run solver first, then perform revision")
        else:
            save_attempt(log_dir, example_id, python_file, 0, run_type, constraint_type)
            success = True

    if not success:
        save_attempt(log_dir, example_id, python_file, solver_attempt, run_type, constraint_type)

def run_pipeline_deepseek(client, domain, data, model, run_type, constraint_type, problems, constraints):
    log_dir = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/revisions'

    for problem, constraint in zip(problems, constraints):
        print(f"Processing: {problem}_{constraint}")
        process_example_deepseek(client, domain, data, model, run_type, constraint_type, problem, constraint, log_dir)
        time.sleep(15)

async def run_pipeline_qwen(engine, domain, data, model, run_type, constraint_type, problems, constraints):
    log_dir = f'../../../output/llm-as-smt-formalizer/{domain}/{data}/revisions'

    for problem, constraint in zip(problems, constraints):
        await process_example_qwen(engine, domain, data, model, run_type, constraint_type, problem, constraint, log_dir)

def main(domain, data, model, run_type, constraint_type, default, problems, constraints):
    if default:
        problem_names, constraint_names = get_default(domain, data, constraint_type)
    else:
        problem_names, constraint_names = problem_and_constraint_names(problems, constraints)

    if "deepseek" in model:
        openai_api_key = open(f'../../../../../_private/key_deepseek.txt').read()
        client = OpenAI(api_key=openai_api_key, base_url="https://api.deepseek.com")
        run_pipeline_deepseek(client, domain, data, model, run_type, constraint_type, problem_names, constraint_names)
    else:
        engine = HuggingEngine(model_id = f"Qwen/{model}", model_load_kwargs={"device_map": "auto"})
        asyncio.run(run_pipeline_qwen(engine, domain, data, model, run_type, constraint_type, problem_names, constraint_names))
    

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
    main(domain, data, model, run_type, constraint_type, default, problems, constraints)
