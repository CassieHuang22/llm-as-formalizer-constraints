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
parser.add_argument("--constraint_type", help="which constraint to evaluate", choices=["initial", "goal", "state-based", "sequential", "numerical", "baseline"])
parser.add_argument("--problems", type=str, required=True, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")
parser.add_argument("--constraints", type=str, required=True, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)")

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
    domain_description = open(f'../../data/{domain}/{data}/descriptions/{problem}_domain.txt').read()
    problem_description = open(f'../../data/{domain}/{data}/descriptions/{problem}_problem.txt').read()
    constraint_description = open(f'../../data/{domain}/{data}/constraints/{constraint_type}/descriptions/{constraint}.txt').read()
    available_actions = open(f'../../data/{domain}/{data}/constraints/{constraint_type}/action_heads/{problem}_{constraint}.txt').read()
    if domain == "blocksworld":
        example_answer = '(PICK-UP A)\n(STACK A B)\n(UNSTACK A B)\n(PUT-DOWN A)\n'
    elif domain == "mystery_blocksworld":
        example_answer = '(action1 object1)\n(action3 object1 object2)\n(action4 object1 object2)\n(action2 object1)\n'
    else:
        example_answer = '(MOVE room1 room1 direction)\n(TAKE coin room2)\n'
    prompt = f"You are a PDDL expert. Here is a game we are playing.\n{domain_description}\n{problem_description}\n{constraint_description}\n\nWrite the plan that would solve this problem.\n\nThese are the available actions:\n{available_actions}\n\nHere is what the output should look like:\n{example_answer}\n"
    message = prompt + "The output should be a list of strings written inside a JSON object in the following format:\n{\n  \"plan\": ...,\n}"

    completion = client.chat.completions.create(
        model=model,
        messages=[
        {"role": "user", "content": message}
        ],
        response_format = {"type": "json_object"}
    )

    output = completion.choices[0].message.content
    output_json = json.loads(output, strict=False)
    plan = output_json['plan']
    plan_path = f'../../output/llm-as-planner/{domain}/{data}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_plan.txt'

    if not os.path.exists(os.path.dirname(plan_path)):
        os.makedirs(os.path.dirname(plan_path))

    with open(plan_path, 'w') as file:
        for line in plan:
            file.write(f"{line}\n")
    
    return plan

async def run_qwen(engine, domain, data, model, constraint_type, problem, constraint):
    prompt = "Respond only as shown."
    domain_description = open(f'../../data/{domain}/{data}/descriptions/{problem}_domain.txt').read()
    problem_description = open(f'../../data/{domain}/{data}/descriptions/{problem}_problem.txt').read()
    constraint_description = open(f'../../data/{domain}/{data}/constraints/{constraint_type}/descriptions/{constraint}.txt').read()
    available_actions = open(f'../../data/{domain}/{data}/constraints/{constraint_type}/action_heads/{problem}_{constraint}.txt').read()
    if domain == "blocksworld":
        example_answer = '(PICK-UP A)\n(STACK A B)\n(UNSTACK A B)\n(PUT-DOWN A)\n'
    elif domain == "mystery_blocksworld":
        example_answer = '(action1 object1)\n(action3 object1 object2)\n(action4 object1 object2)\n(action2 object1)\n'
    else:
        example_answer = '(MOVE room1 room2 direction)\n(TAKE coin room2)\n'
    message = f"Here is a game we are playing.\n\n{domain_description}\n\n{problem_description}\n\n{constraint_description}\n\nWrite the plan that would solve this problem.\n\nThese are the available actions:\n{available_actions}\n\nHere is what the output should look like:\n{example_answer}\n"

    message += "The output should be a list of strings written inside a JSON object in the following format:\n{\n  \"plan\": [\"...\",\"...\",...]\n}"
    ai = Kani(engine, system_prompt=prompt)
    response = await ai.chat_round_str(message)
    start_index = response.find('{')
    end_index = response.find('}')
    json_string = response[start_index:end_index+1]
    output_dict = json.loads(json_string, strict=False)
    plan = output_dict['plan']
    plan_path = f'../../output/llm-as-planner/{domain}/{data}/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_plan.txt'

    if not os.path.exists(os.path.dirname(plan_path)):
        os.makedirs(os.path.dirname(plan_path))

    with open(plan_path, 'w') as file:
        for line in plan:
            file.write(f"{line}\n")
    
    return plan


def run_deepseek_batch(client, domain, data, model, constraint_type, problems, constraints):
    print(f"Running {model} with {constraint_type}...")
    max_malformed_attempts = 3
    for problem, constraint in zip(problems, constraints):
        print(f"Running {problem}_{constraint}")
        for attempt in range(1, max_malformed_attempts + 1):
            try:
                run_deepseek(
                    client, domain, data, model, constraint_type, problem, constraint
                )
                break
            except Exception as e:
                print(f"Attempt {attempt} failed: {e}")
        else:
            print(f"cannot generate {problem}_{constraint}")

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

def main(domain, data, model, constraint_type, problems, constraints):
    problem_names, constraint_names = problem_and_constraint_names(problems, constraints)
    if "deepseek" in model:
        openai_api_key = open(f'../../../../_private/key_deepseek.txt').read()
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
    problems = args.problems
    constraints = args.constraints
    main(domain=domain, data=data, model=model, constraint_type=constraint_type, problems=problems, constraints=constraints)
    