from openai import OpenAI
import json
import os
from kani import Kani
from kani.engines.huggingface import HuggingEngine
import argparse
import asyncio 

parser = argparse.ArgumentParser()
parser.add_argument("--domain", help="which domain to evaluate", choices=["blocksworld", "mystery_blocksworld", "coin_collector"])
parser.add_argument("--data", help="which dataset to evaluate", choices=["BlocksWorld-100", "Mystery_BlocksWorld-100", "BlocksWorld-100-XL", "CoinCollector-100_includeDoors0"])
parser.add_argument("--model", help="which model to use", choices=["deepseek-reasoner", "deepseek-chat", "Qwen3-32B", "Qwen2.5-Coder-32B-Instruct"])
parser.add_argument("--problems", type=str, required=True, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")

def get_problem_names(problems):
    problem_numbers = []
    for part in problems.split(","):
        if "-" in part:
            start, end = map(int, part.split("-"))
            problem_numbers.extend(range(start, end+1))
        else:
            problem_numbers.append(int(part))
    problem_names = [f'p0{problem_number}' if problem_number < 10 else f'p{problem_number}' for problem_number in problem_numbers]
    return problem_names

def run_deepseek(client, domain, data, model, problem):
    domain_description = open(f'../../../data/{domain}/{data}/descriptions/{problem}_domain.txt').read()
    problem_description = open(f'../../../data/{domain}/{data}/descriptions/{problem}_problem.txt').read()
    available_actions = open(f'../../../data/{domain}/{data}/action_heads/action_heads.txt').read()
    prompt = f"You are a PDDL expert. Here is a game we are playing.\n{domain_description}\n{problem_description}\nWrite the domain and problem files in minimal PDDL.\n\nThese are the available actions:\n{available_actions}\n"
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


    df_path = f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_df.pddl'
    pf_path = f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_pf.pddl'

    if not os.path.exists(os.path.dirname(df_path)):
        os.makedirs(os.path.dirname(df_path))
        
    with open(df_path, 'w') as df:
        df.write(domain_file)
    
    with open(pf_path, 'w') as pf:
        pf.write(problem_file)

    return domain_file, problem_file

async def run_qwen(engine, domain, data, model, problem):
    prompt = "Respond only as shown."
    domain_description = open(f'../../../data/{domain}/{data}/descriptions/{problem}_domain.txt').read()
    problem_description = open(f'../../../data/{domain}/{data}/descriptions/{problem}_problem.txt').read()
    available_actions = open(f'../../../data/{domain}/{data}/action_heads/action_heads.txt').read()

    message = f"You are a PDDL expert. Here is a game we are playing.\n\n{domain_description}\n\n{problem_description}\nWrite the domain and problem files in minimal PDDL.\n\nThese are the available actions:\n{available_actions}\n"

    message += "Return a JSON object in the following format:\n{\n  \"domain file\": ...,\n  \"problem file\":...\n}"
    
    ai = Kani(engine, system_prompt=prompt)
    response = await ai.chat_round_str(message)
    start_index = response.find('{')
    end_index = response.find('}')
    json_string = response[start_index:end_index+1]
    output_dict = json.loads(json_string, strict=False)
    domain_file = output_dict["domain file"]
    problem_file = output_dict["problem file"]

    df_path = f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_df.pddl'
    pf_path = f'../../../output/llm-as-pddl-formalizer/{domain}/{data}/edit/{model}/original/{problem}/{problem}_{model}_pf.pddl'

    if not os.path.exists(os.path.dirname(df_path)):
        os.makedirs(os.path.dirname(df_path))
        
    with open(df_path, 'w') as df:
        df.write(domain_file)
    
    with open(pf_path, 'w') as pf:
        pf.write(problem_file)

    return domain_file, problem_file


def run_deepseek_batch(client, domain, data, model, problems):
    print(f"Running {model}...")
    max_malformed_attempts = 3
    for problem in problems:
        print(f"Running {problem}")
        for attempt in range(1, max_malformed_attempts + 1):
            try:
                domain_file, problem_file = run_deepseek(
                    client, domain, data, model, problem
                )
                break
            except Exception as e:
                print(f"Attempt {attempt} failed: {e}")
        else:
            print(f"cannot generate {problem}")

async def run_qwen_batch(engine, domain, data, model, problems):
    max_malformed_attempts = 3
    for problem in problems:
        print(f"Running {problem}")
        for attempt in range(1, max_malformed_attempts + 1):
            try:
                domain_file, problem_file = await run_qwen(
                    engine, domain, data, model, problem
                )
                break
            except Exception as e:
                print(f"Attempt {attempt} failed: {e}")
        else:
            print(f"cannot generate {problem}")

def main(domain, data, model, problems):
    problem_names = get_problem_names(problems)
    if "deepseek" in model:
        openai_api_key = open(f'../../../../../_private/key_deepseek.txt').read()
        client = OpenAI(api_key=openai_api_key, base_url="https://api.deepseek.com")
        run_deepseek_batch(client, domain, data, model, problem_names)
    elif "Qwen" in model:
        engine = HuggingEngine(model_id = f"Qwen/{model}", model_load_kwargs={"device_map": "auto"})
        asyncio.run(run_qwen_batch(engine, domain, data, model, problem_names))

if __name__=="__main__":
    args = parser.parse_args()
    domain = args.domain
    data = args.data
    model = args.model
    problems = args.problems
    main(domain=domain, data=data, model=model, problems=problems)
    