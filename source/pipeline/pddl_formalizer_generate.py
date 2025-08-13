from openai import OpenAI
import json
import os
import time
from kani import Kani
from kani.engines.huggingface import HuggingEngine
import argparse
import asyncio 

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to evaluate", choices=["blocksworld", "mystery_blocksworld"])
parser.add_argument("--data", help="which dataset to evaluate", choices=["BlocksWorld-100", "Mystery_BlocksWorld-100", "BlocksWorld-100-XL"])
parser.add_argument("--model", help="which model to use", choices=["deepseek-reasoner", "deepseek-chat", "Qwen3-32B", "Qwen2.5-Coder-32B-Instruct"])
parser.add_argument("--constraint_type", help="which constraint to evaluate", choices=["initial", "goal", "state-based", "sequential", "numerical", "baseline"])
parser.add_argument("--default", action='store_true')
parser.add_argument("--problem_start", type=int)
parser.add_argument("--problem_end", type=int)
parser.add_argument("--constraint_start", type=int)
parser.add_argument("--constraint_end", type=int)

def parse_json_file(domain, data, constraint_type):
    jsonl_file_path = f'../../data/{domain}/{data}/constraints/{constraint_type}/pddl/groundtruth_plan_info.jsonl'
    problem_configs = {}
    with open(jsonl_file_path) as jsonl_file:
        for line in jsonl_file:
            groundtruth_plan_info = json.loads(line)

            problem_name = groundtruth_plan_info["problem"]
            constraint_name = groundtruth_plan_info["constraint"]
            plan_exists = groundtruth_plan_info["plan_exists"]
            problem_configs.setdefault(problem_name, {})[constraint_name] = plan_exists
    
    return problem_configs

def run_deepseek(client, domain, data, model, constraint_type, problem, constraint):
    domain_description = open(f'../../data/{domain}/{data}/descriptions/{problem}_domain.txt').read()
    problem_description = open(f'../../data/{domain}/{data}/descriptions/{problem}_problem.txt').read()
    constraint_description = open(f'../../data/{domain}/{data}/constraints/{constraint_type}/descriptions/{constraint}.txt').read()
    available_actions = open(f'../../data/{domain}/{data}/constraints/{constraint_type}/action_heads/{problem}_{constraint}.txt').read()
    prompt = f"You are a PDDL expert. Here is a game we are playing.\n{domain_description}\n{problem_description}\n{constraint_description}\n\nWrite the domain and problem files in minimal PDDL.\n\nThese are the available actions:\n{available_actions}\n"
    message = prompt + "Return a JSON object in the following format:\n{\n  \"domain file\": ...,\n  \"problem file\":...\n}"

    completion = client.chat.completions.create(
        model=model,
        messages=[
        {"role": "user", "content": message}
        ],
        response_format = {"type": "text"}
    )

    output = completion.choices[0].message.content
    start_index = output.find('{')
    end_index = output.find('}')
    json_string = output[start_index:end_index+1]
    output_dict = json.loads(json_string, strict=False)
    domain_file = output_dict["domain file"]
    problem_file = output_dict["problem file"]


    df_path = f'../../output/llm-as-formalizer/{domain}/{data}/generate/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_df.pddl'
    pf_path = f'../../output/llm-as-formalizer/{domain}/{data}/generate/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_pf.pddl'

    if not os.path.exists(os.path.dirname(df_path)):
        os.makedirs(os.path.dirname(df_path))
        
    with open(df_path, 'w') as df:
        df.write(domain_file)
    
    with open(pf_path, 'w') as pf:
        pf.write(problem_file)

    return domain_file, problem_file

async def run_qwen(engine, domain, data, model, constraint_type, problem, constraint):
    prompt = "Respond only as shown."
    domain_description = open(f'../../data/{domain}/{data}/descriptions/{problem}_domain.txt').read()
    problem_description = open(f'../../data/{domain}/{data}/descriptions/{problem}_problem.txt').read()
    constraint_description = open(f'../../data/{domain}/{data}/constraints/{constraint_type}/descriptions/{constraint}.txt').read()
    available_actions = open(f'../../data/{domain}/{data}/constraints/{constraint_type}/action_heads/{problem}_{constraint}.txt').read()

    message = f"You are a PDDL expert. Here is a game we are playing.\n\n{domain_description}\n\n{problem_description}\n\n{constraint_description}\n\nWrite the domain and problem files in minimal PDDL.\n\nThese are the available actions:\n{available_actions}\n"

    message += "Return a JSON object in the following format:\n{\n  \"domain file\": ...,\n  \"problem file\":...\n}"
    malformed_attempt = 1
    max_malformed_attempts = 3
    while malformed_attempt < max_malformed_attempts:
        try:
            ai = Kani(engine, system_prompt=prompt)
            response = await ai.chat_round_str(message)
            start_index = response.find('{')
            end_index = response.find('}')
            json_string = response[start_index:end_index+1]
            output_dict = json.loads(json_string, strict=False)
            domain_file = output_dict["domain file"]
            problem_file = output_dict["problem file"]
            break
        except:
            malformed_attempt += 1
    else:
        print(f"cannot generate {problem}_{constraint}")

    df_path = f'../../output/llm-as-formalizer/{domain}/{data}/generate/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_df.pddl'
    pf_path = f'../../output/llm-as-formalizer/{domain}/{data}/generate/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_pf.pddl'

    if not os.path.exists(os.path.dirname(df_path)):
        os.makedirs(os.path.dirname(df_path))
        
    with open(df_path, 'w') as df:
        df.write(domain_file)
    
    with open(pf_path, 'w') as pf:
        pf.write(problem_file)

    return domain_file, problem_file


def run_deepseek_batch(client, domain, data, model, constraint_type, problems, constraints):
    print(f"Running {model} with {constraint_type} constraints...")
    malformed_attempt = 1
    max_malformed_attempts = 3
    for problem, constraint in zip(problems, constraints):
        print(f"Running {problem}_{constraint}")
        while malformed_attempt <= max_malformed_attempts:
            try:
                run_deepseek(client, domain, data, model, constraint_type, problem, constraint)
                break
            except:
                malformed_attempt += 1
        else:
            print(f"cannot generate {problem}_{constraint}")
            malformed_attempt = 1
        time.sleep(15)

async def run_qwen_batch(engine, domain, data, model, constraint_type, problems, constraints):
    tasks = [run_qwen(engine, domain, data, model, constraint_type, problem, constraint) for problem, constraint in zip(problems, constraints)]
    outputs = await asyncio.gather(*tasks)
    return outputs

def main(domain, data, model, constraint_type, default, problem_start, problem_end, constraint_start, constraint_end):
    if default:
        problem_configs = parse_json_file(domain, data, constraint_type)
        problems = list(problem_configs.keys())
        constraints = [list(problem_configs[problem_name].keys())[0] for problem_name in problems]
    else:
        problems = ['p0' + str(problem_number) if problem_number < 10 else 'p' + str(problem_number) for problem_number in range(problem_start, problem_end)]
        constraints = [f'constraint{constraint_number}' for constraint_number in range(constraint_start, constraint_end)]
    if "deepseek" in model:
        openai_api_key = open(f'../../../../_private/key_deepseek.txt').read()
        client = OpenAI(api_key=openai_api_key, base_url="https://api.deepseek.com")
        run_deepseek_batch(client, domain, data, model, constraint_type, problems, constraints)
    elif "Qwen" in model:
        engine = HuggingEngine(model_id = f"Qwen/{model}")
        asyncio.run(run_qwen_batch(engine, domain, data, model, constraint_type, problems, constraints))

if __name__=="__main__":
    args = parser.parse_args()
    domain = args.domain
    data = args.data
    model = args.model
    constraint_type = args.constraint_type
    default = args.default
    problem_start = args.problem_start
    problem_end = args.problem_end
    constraint_start = args.constraint_start
    constraint_end = args.constraint_end
    main(domain=domain, data=data, model=model, constraint_type=constraint_type, default=default, problem_start=problem_start, problem_end=problem_end, constraint_start=constraint_start, constraint_end=constraint_end)
    