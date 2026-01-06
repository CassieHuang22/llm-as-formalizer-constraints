from openai import OpenAI
import json
import os
import time
from kani import Kani
from kani.engines.huggingface import HuggingEngine
import argparse
import asyncio 

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to evaluate", choices=["blocksworld", "mystery_blocksworld", "coin_collector"])
parser.add_argument("--data", help="which dataset to evaluate", choices=["BlocksWorld-100", "Mystery_BlocksWorld-100", "BlocksWorld-100-XL", "CoinCollector-100_includeDoors0"])
parser.add_argument("--model", help="which model to use", choices=["deepseek-reasoner", "deepseek-chat", "Qwen3-32B", "Qwen2.5-Coder-32B-Instruct"])
parser.add_argument("--constraint_type", help="which constraint to evaluate", choices=["initial", "goal", "action", "state", "baseline"])
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

def run_deepseek(client, domain, data, model, constraint_type, problem, constraint):
    domain_description = open(f'../../../data/{domain}/{data}/descriptions/{problem}_domain.txt').read()
    problem_description = open(f'../../../data/{domain}/{data}/descriptions/{problem}_problem.txt').read()
    constraint_description = open(f'../../../data/{domain}/{data}/constraints/{constraint_type}/descriptions/{constraint}.txt').read()
    available_actions = open(f'../../../data/{domain}/{data}/constraints/{constraint_type}/action_heads/{problem}_{constraint}.txt').read()
    prompt = f"You are a PDDL3 expert. Here is a game we are playing.\n{domain_description}\n{problem_description}\n{constraint_description}\n\nWrite the domain and problem files in minimal PDDL3 code.\n\nThese are the available actions:\n{available_actions}\n"
    message = prompt + "Return a JSON object in the following format:\n{\n  \"domain file\": ...,\n  \"problem file\":...\n}"

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


    df_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/generate/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_df.pddl'
    pf_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/generate/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_pf.pddl'

    if not os.path.exists(os.path.dirname(df_path)):
        os.makedirs(os.path.dirname(df_path))
        
    with open(df_path, 'w') as df:
        df.write(domain_file)
    
    with open(pf_path, 'w') as pf:
        pf.write(problem_file)

    return domain_file, problem_file

async def run_qwen(engine, domain, data, model, constraint_type, problem, constraint):
    prompt = "Respond only as shown."
    domain_description = open(f'../../../data/{domain}/{data}/descriptions/{problem}_domain.txt').read()
    problem_description = open(f'../../../data/{domain}/{data}/descriptions/{problem}_problem.txt').read()
    constraint_description = open(f'../../../data/{domain}/{data}/constraints/{constraint_type}/descriptions/{constraint}.txt').read()
    available_actions = open(f'../../../data/{domain}/{data}/constraints/{constraint_type}/action_heads/{problem}_{constraint}.txt').read()

    message = f"You are a PDDL3 expert. Here is a game we are playing.\n\n{domain_description}\n\n{problem_description}\n\n{constraint_description}\n\nWrite the domain and problem files in minimal PDDL3 code.\n\nThese are the available actions:\n{available_actions}\n"

    message += "Return a JSON object in the following format:\n{\n  \"domain file\": ...,\n  \"problem file\":...\n}"
    ai = Kani(engine, system_prompt=prompt)
    response = await ai.chat_round_str(message)
    start_index = response.find('{')
    end_index = response.find('}')
    json_string = response[start_index:end_index+1]
    output_dict = json.loads(json_string, strict=False)
    domain_file = output_dict["domain file"]
    problem_file = output_dict["problem file"]

    df_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/generate/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_df.pddl'
    pf_path = f'../../../output/llm-as-pddl3-formalizer/{domain}/{data}/generate/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_pf.pddl'

    if not os.path.exists(os.path.dirname(df_path)):
        os.makedirs(os.path.dirname(df_path))
        
    with open(df_path, 'w') as df:
        df.write(domain_file)
    
    with open(pf_path, 'w') as pf:
        pf.write(problem_file)

    return domain_file, problem_file


def run_deepseek_batch(client, domain, data, model, constraint_type, problems, constraints):
    print(f"Running {model} with {constraint_type}...")
    max_malformed_attempts = 3
    for problem, constraint in zip(problems, constraints):
        print(f"Running {problem}_{constraint}")
        for attempt in range(1, max_malformed_attempts + 1):
            try:
                domain_file, problem_file = run_deepseek(
                    client, domain, data, model, constraint_type, problem, constraint
                )
                break
            except Exception as e:
                print(f"Attempt {attempt} failed: {e}")
        else:
            print(f"cannot generate {problem}_{constraint}")
        time.sleep(15)

async def run_qwen_batch(engine, domain, data, model, constraint_type, problems, constraints):
    print(f"Running {model} with {constraint_type}...")
    max_malformed_attempts = 3
    for problem, constraint in zip(problems, constraints):
        print(f"Running {problem}_{constraint}")
        for attempt in range(1, max_malformed_attempts + 1):
            try:
                domain_file, problem_file = await run_qwen(
                    engine, domain, data, model, constraint_type, problem, constraint
                )
                break
            except Exception as e:
                print(f"Attempt {attempt} failed: {e}")
        else:
            print(f"cannot generate {problem}_{constraint}")

def main(domain, data, model, constraint_type, default, problems, constraints):
    if default:
        problem_names, constraint_names = get_default(domain, data, constraint_type)
    else:
        problem_names, constraint_names = problem_and_constraint_names(problems, constraints)
    if "deepseek" in model:
        openai_api_key = open(f'../../../../../_private/key_deepseek.txt').read()
        client = OpenAI(api_key=openai_api_key, base_url="https://api.deepseek.com")
        run_deepseek_batch(client, domain, data, model, constraint_type, problem_names, constraint_names)
    elif "Qwen" in model:
        engine = HuggingEngine(model_id = f"Qwen/{model}", model_load_kwargs={"device_map": "auto"})
        asyncio.run(run_qwen_batch(engine, domain, data, model, constraint_type, problem_names, constraint_names))

if __name__=="__main__":
    args = parser.parse_args()
    domain = args.domain
    data = args.data
    model = args.model
    constraint_type = args.constraint_type
    default = args.default
    problems = args.problems
    constraints = args.constraints
    main(domain=domain, data=data, model=model, constraint_type=constraint_type, default=default, problems=problems, constraints=constraints)
    