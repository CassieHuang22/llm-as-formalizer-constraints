from openai import OpenAI
import json
import os
import time
from kani import Kani
from kani.engines.huggingface import HuggingEngine
import argparse
import asyncio
import shutil

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to evaluate", choices=["blocksworld", "mystery_blocksworld", "coin_collector"])
parser.add_argument("--data", help="which dataset to evaluate", choices=["BlocksWorld-100", "Mystery_BlocksWorld-100", "BlocksWorld-100-XL", "CoinCollector-100_includeDoors0"])
parser.add_argument("--model", help="which model to use", choices=["deepseek-reasoner", "deepseek-chat", "Qwen3-32B", "Qwen2.5-Coder-32B-Instruct"])
parser.add_argument("--constraint_type", help="which constraint to evaluate", choices=["initial", "goal", "action", "state", "baseline"])
parser.add_argument("--run_type", choices=["generate", "edit"])
parser.add_argument("--default", action="store_true")
parser.add_argument("--problems", type=str, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")
parser.add_argument("--constraints", type=str, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")
parser.add_argument("--attempt", type=int, help="which attempt to generate")

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

def write_num_attempts_file(path, num_attempts):
    num_attempts_path = os.path.join(path, 'num_attempts.txt')
    with open(num_attempts_path, 'w') as num_attempts_file:
        num_attempts_file.write(str(num_attempts))

def run_initial_attempt(domain, data, model, constraint_type, run_type, problems, constraints):
    for problem, constraint in zip(problems, constraints):
        source_dir = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/{run_type}/{model}/{constraint_type}/{problem}'
        target_dir = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt0/{problem}'

        shutil.copytree(source_dir, target_dir, dirs_exist_ok=True)
        error_file_path = os.path.join(source_dir, f'{problem}_{constraint}_{model}_error.txt')
        if not os.path.exists(error_file_path):
            write_num_attempts_file(target_dir, 0)

def revise_compilation_deepseek(client, domain, data, model, constraint_type, run_type, problem, constraint, attempt):
    original_domain_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_df.pddl').read()
    original_problem_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_pf.pddl').read()
    compilation_error = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_error.txt').read()

    message = f"""You are a PDDL3 expert. The following PDDL3 were compiled and resulted in an error. Revise the PDDL3 to remove the error. Return a JSON object in the following format:
{{
\"domain file\": ...,
\"problem file\":...
}}

Domain File:
{original_domain_file}

Problem File:
{original_problem_file}

Error Message:
{compilation_error}

"""
    completion = client.chat.completions.create(
        model=model,
        messages=[
        {"role": "user", "content": message}
        ],
        response_format = {"type": "json_object"}
    )

    output = completion.choices[0].message.content
    output_dict = json.loads(output, strict=False)
    domain_file = output_dict["domain file"]
    problem_file = output_dict["problem file"]

    df_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt}/{problem}/{problem}_{constraint}_{model}_df.pddl'
    pf_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt}/{problem}/{problem}_{constraint}_{model}_pf.pddl'

    if not os.path.exists(os.path.dirname(df_path)):
        os.makedirs(os.path.dirname(df_path))

    with open(df_path, 'w') as df:
        df.write(domain_file)
    
    with open(pf_path, 'w') as pf:
        pf.write(problem_file)

def revise_solver_deepseek(client, domain, data, model, constraint_type, run_type, problem, constraint, attempt):
    original_domain_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_df.pddl').read()
    original_problem_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_pf.pddl').read()
    compiled_domain_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_compiled_result/compiled_dom.pddl').read()
    compiled_problem_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_compiled_result/compiled_prob.pddl').read()
    solver_error = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_error.txt').read()

    message = f"""You are a PDDL3 expert. The following PDDL3 were compiled and ran through a solver, which resulted in an error. Revise the original PDDL3 to remove the error. Return a JSON object in the following format:
{{
\"domain file\": ...,
\"problem file\":...
}}

Original Domain File:
{original_domain_file}

Original Problem File:
{original_problem_file}

Compiled Domain File:
{compiled_domain_file}

Compiled Problem File:
{compiled_problem_file}

Error Message:
{solver_error}

"""
    completion = client.chat.completions.create(
        model=model,
        messages=[
        {"role": "user", "content": message}
        ],
        response_format = {"type": "json_object"}
    )

    output = completion.choices[0].message.content
    output_dict = json.loads(output, strict=False)
    domain_file = output_dict["domain file"]
    problem_file = output_dict["problem file"]

    df_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt}/{problem}/{problem}_{constraint}_{model}_df.pddl'
    pf_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt}/{problem}/{problem}_{constraint}_{model}_pf.pddl'

    if not os.path.exists(os.path.dirname(df_path)):
        os.makedirs(os.path.dirname(df_path))

    with open(df_path, 'w') as df:
        df.write(domain_file)
    
    with open(pf_path, 'w') as pf:
        pf.write(problem_file)

async def revise_compilation_qwen(engine, domain, data, model, constraint_type, run_type, problem, constraint, attempt):
    original_domain_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_df.pddl').read()
    original_problem_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_pf.pddl').read()
    compilation_error = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_error.txt').read()

    message = f"""You are a PDDL3 expert. The following PDDL3 were compiled and resulted in an error. Revise the PDDL3 to remove the error. Return a JSON object in the following format:
{{
\"domain file\": ...,
\"problem file\":...
}}

Domain File:
{original_domain_file}

Problem File:
{original_problem_file}

Error Message:
{compilation_error}

"""
    prompt = "Respond only as shown."
    ai = Kani(engine, system_prompt=prompt)
    response = await ai.chat_round_str(message)
    start_index = response.find('{')
    end_index = response.find('}')
    json_string = response[start_index:end_index+1]
    output_dict = json.loads(json_string, strict=False)
    domain_file = output_dict["domain file"]
    problem_file = output_dict["problem file"]

    df_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt}/{problem}/{problem}_{constraint}_{model}_df.pddl'
    pf_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt}/{problem}/{problem}_{constraint}_{model}_pf.pddl'

    if not os.path.exists(os.path.dirname(df_path)):
        os.makedirs(os.path.dirname(df_path))

    with open(df_path, 'w') as df:
        df.write(domain_file)
    
    with open(pf_path, 'w') as pf:
        pf.write(problem_file)

    return domain_file, problem_file

async def revise_solver_qwen(engine, domain, data, model, constraint_type, run_type, problem, constraint, attempt):
    original_domain_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_df.pddl').read()
    original_problem_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_pf.pddl').read()
    compiled_domain_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_compiled_result/compiled_dom.pddl').read()
    compiled_problem_file = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_compiled_result/compiled_prob.pddl').read()
    solver_error = open(f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}/{problem}_{constraint}_{model}_error.txt').read()

    message = f"""You are a PDDL3 expert. The following PDDL3 were compiled and ran through a solver, which resulted in an error. Revise the original PDDL3 to remove the error. Return a JSON object in the following format:
{{
\"domain file\": ...,
\"problem file\":...
}}

Original Domain File:
{original_domain_file}

Original Problem File:
{original_problem_file}

Compiled Domain File:
{compiled_domain_file}

Compiled Problem File:
{compiled_problem_file}

Error Message:
{solver_error}

"""

    prompt = "Respond only as shown."
    ai = Kani(engine, system_prompt=prompt)
    response = await ai.chat_round_str(message)
    start_index = response.find('{')
    end_index = response.find('}')
    json_string = response[start_index:end_index+1]
    output_dict = json.loads(json_string, strict=False)
    domain_file = output_dict["domain file"]
    problem_file = output_dict["problem file"]

    df_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt}/{problem}/{problem}_{constraint}_{model}_df.pddl'
    pf_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt}/{problem}/{problem}_{constraint}_{model}_pf.pddl'

    if not os.path.exists(os.path.dirname(df_path)):
        os.makedirs(os.path.dirname(df_path))

    with open(df_path, 'w') as df:
        df.write(domain_file)
    
    with open(pf_path, 'w') as pf:
        pf.write(problem_file)

    return domain_file, problem_file

def run_deepseek_batch(client, domain, data, model, constraint_type, run_type, problems, constraints, attempt):
    print(f"Running {domain}_{data}_{model}_{run_type}_{constraint_type}")
    for problem, constraint in zip(problems, constraints):
        print(f"Running {problem}_{constraint}")
        previous_attempt_dir = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}'
        current_attempt_dir = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt}/{problem}'
        num_attempts_path = os.path.join(previous_attempt_dir, 'num_attempt.txt')
        error_file_path = os.path.join(previous_attempt_dir, f'{problem}_{constraint}_{model}_error.txt')
        plan_file_path = os.path.join(previous_attempt_dir, f'{problem}_{constraint}_{model}_plan.txt')
        output_file_path = os.path.join(previous_attempt_dir, f'{problem}_{constraint}_{model}_output.txt')
        compiled_folder_path = os.path.join(previous_attempt_dir, f'{problem}_{constraint}_{model}_compiled_result')
        if os.path.exists(num_attempts_path):
            shutil.copytree(previous_attempt_dir, current_attempt_dir, dirs_exist_ok=True)
        elif not os.path.exists(error_file_path):
            if not os.path.exists(plan_file_path) and not os.path.exists(output_file_path):
                raise Exception("run compiler and solver first")
            write_num_attempts_file(previous_attempt_dir, attempt-1)
            shutil.copytree(previous_attempt_dir, current_attempt_dir, dirs_exist_ok=True)
        elif not os.path.exists(compiled_folder_path):
            revise_compilation_deepseek(client, domain, data, model, constraint_type, run_type, problem, constraint, attempt)
        else:
            revise_solver_deepseek(client, domain, data, model, constraint_type, run_type, problem, constraint, attempt)

async def run_qwen_batch(engine, domain, data, model, constraint_type, problems, constraints, attempt):
    print(f"Running {domain}_{data}_{model}_{run_type}_{constraint_type}")
    for problem, constraint in zip(problems, constraints):
        print(f"Running {problem}_{constraint}")
        previous_attempt_dir = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt-1}/{problem}'
        current_attempt_dir = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/revisions/{run_type}/{model}/{constraint_type}/attempt{attempt}/{problem}'
        num_attempts_path = os.path.join(previous_attempt_dir, 'num_attempt.txt')
        error_file_path = os.path.join(previous_attempt_dir, f'{problem}_{constraint}_{model}_error.txt')
        plan_file_path = os.path.join(previous_attempt_dir, f'{problem}_{constraint}_{model}_plan.txt')
        output_file_path = os.path.join(previous_attempt_dir, f'{problem}_{constraint}_{model}_output.txt')
        compiled_folder_path = os.path.join(previous_attempt_dir, f'{problem}_{constraint}_{model}_compiled_result')
        max_malformed_attempts = 3
        if os.path.exists(num_attempts_path):
            shutil.copytree(previous_attempt_dir, current_attempt_dir, dirs_exist_ok=True)
        elif not os.path.exists(error_file_path):
            if not os.path.exists(plan_file_path) and not os.path.exists(output_file_path):
                raise Exception("run compiler and solver first")
            write_num_attempts_file(previous_attempt_dir, attempt-1)
            shutil.copytree(previous_attempt_dir, current_attempt_dir, dirs_exist_ok=True)
        elif not os.path.exists(compiled_folder_path):
            for malformed_attempt in range(1, max_malformed_attempts + 1):
                try:
                    revised_domain, revised_problem = await revise_compilation_qwen(engine, domain, data, model, constraint_type, run_type, problem, constraint, attempt)
                    break
                except Exception as e:
                    print(f"Attempt {malformed_attempt} failed: {e}")
            else:
                print(f"cannot generate {problem}_{constraint}")
        else:
            for malformed_attempt in range(1, max_malformed_attempts + 1):
                try:
                    revised_domain, revised_problem = await revise_solver_qwen(engine, domain, data, model, constraint_type, run_type, problem, constraint, attempt)
                    break
                except Exception as e:
                    print(f"Attempt {malformed_attempt} failed: {e}")
            else:
                print(f"cannot generate {problem}_{constraint}")

def main(domain, data, model, constraint_type, run_type, default, problems, constraints, attempt):
    if default:
        problem_names, constraint_names = get_default(domain, data, constraint_type)
    else:
        problem_names, constraint_names = problem_and_constraint_names(problems, constraints)
    
    if attempt == 0:
        run_initial_attempt(domain, data, model, constraint_type, run_type, problem_names, constraint_names)
    elif "deepseek" in model:
        openai_api_key = open(f'../../../../../_private/key_deepseek.txt').read()
        client = OpenAI(api_key=openai_api_key, base_url="https://api.deepseek.com")
        run_deepseek_batch(client, domain, data, model, constraint_type, run_type, problem_names, constraint_names, attempt)
    elif "Qwen" in model:
        engine = HuggingEngine(model_id = f"Qwen/{model}", model_load_kwargs={"device_map": "auto"})
        asyncio.run(run_qwen_batch(engine, domain, data, model, constraint_type, problem_names, constraint_names, attempt))

if __name__=="__main__":
    args = parser.parse_args()
    domain = args.domain
    data = args.data
    model = args.model
    constraint_type = args.constraint_type
    run_type = args.run_type
    default = args.default
    problems = args.problems
    constraints = args.constraints
    attempt = args.attempt
    main(domain=domain, data=data, model=model, constraint_type=constraint_type, run_type=run_type, default=default, problems=problems, constraints=constraints, attempt=attempt)