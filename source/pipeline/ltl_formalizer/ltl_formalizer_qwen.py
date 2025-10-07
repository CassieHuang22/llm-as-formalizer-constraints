"""Prompt GPT for LTL formulas and get plans. Works for coincollector only."""

import argparse
import json
import re
import os

from kani import Kani
from kani.engines.huggingface import HuggingEngine
from utils import load_from_file, raw_prompt_qwen
from ltl_to_plan import ltl_to_plan
import asyncio

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

async def constrained_planning(engine, domain: str, problem_description: str, constraint_description: str) -> list[str]:
    """
    LTL-based planing from a problem description and constraint description.
    Returns:
    - actions: list of action strings in PDDL style. e.g., (move corridor bedroom east), (take coin bedroom)
    """
    formulas_dict = await get_ltl_from_model(engine, domain, problem_description)
    adjacency = await get_adjacency(engine, domain, problem_description)
    if constraint_description:
        constraints = await get_constraints(engine, domain, problem_description, constraint_description, adjacency)

        # Construct one big LTL formula
        phi = " & ".join([f"({f})" for f in formulas_dict.values()] + [constraints.strip()])
    else:
        phi = " & ".join([f"({f})" for f in formulas_dict.values()])
    # Clean up phi
    phi = phi.replace("\\\n", " ")
    phi = phi.replace("\n", " ")
    phi = re.sub(r"\s+", " ", phi).strip()

    actions = ltl_to_plan(phi, adjacency, debug=False)
    return actions

async def get_ltl_from_model(engine, domain, description, prompt_fpath="./ltl_prompt.yaml"):
    """Prompt qwen for LTL formulas."""
    def construct_prompt(prompt, description):
        return prompt.replace("[DESCRIPTION]", description)

    prompt = load_from_file(prompt_fpath)[f"{domain}_formulas"]
    full_prompt = construct_prompt(prompt, description)
    response = await raw_prompt_qwen(engine=engine, prompt=full_prompt)
    matches = re.findall(r'(\w+)\s*=\s*"([^"]*)"', response)
    formulas_dict: dict[str, str] = {name: expr for name, expr in matches}
    return formulas_dict

async def get_adjacency(engine, domain, description, prompt_fpath="./ltl_prompt.yaml"):
    """Prompt deepseek for room adjacency."""
    def construct_prompt(prompt, description):
        return prompt.replace("[DESCRIPTION]", description)

    prompt = load_from_file(prompt_fpath)[f"{domain}_adjacency"]
    full_prompt = construct_prompt(prompt, description)
    response = await raw_prompt_qwen(engine=engine, prompt=full_prompt)
    response = re.sub(r'^\s*adjacency\s*=\s*', '', response)

    # Load as JSON
    adjacency = json.loads(response)
    return adjacency

async def get_constraints(engine, domain, problem_description, constraint_description, adjacency, prompt_fpath="./ltl_prompt.yaml"):
    """Prompt deepseek to get LTL formulas from NL description of constraints."""
    def construct_prompt(prompt):
        prompt = prompt.replace("[ROOMS]", str(list(adjacency.keys())))
        prompt = prompt.replace("[ENV_DESCRIPTION]", problem_description)
        prompt = prompt.replace("[CONSTRAINTS_DESCRIPTION]", constraint_description)
        return prompt
    
    prompt = load_from_file(prompt_fpath)[f"{domain}_constraints"]
    full_prompt = construct_prompt(prompt)
    response = await raw_prompt_qwen(engine=engine, prompt=full_prompt)
    # breakpoint()
    # load response into json-like dict
    response = re.sub(r'^\s*constraints\s*=\s*', '', response)
    # remove the " or ' on both sides
    response = response.strip().strip('"').strip("'")
    return response

async def run_qwen_ltl(engine, domain, data, model, constraint_type, problem, constraint):
    problem_description = open(f'../../../data/{domain}/{data}/descriptions/{problem}_problem.txt').read().strip()
    constraint_description = open(f'../../../data/{domain}/{data}/constraints/{constraint_type}/descriptions/{constraint}.txt').read().strip()

    num_attempts = 1 if model == "Qwen3-32B" else 5
    for attempt in range(num_attempts):
        try:
            actions = await constrained_planning(engine, domain, problem_description, constraint_description)
            plan_file_path = f'../../../output/llm-as-ltl-formalizer/{domain}/{data}/generate/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_plan.txt'

            if not os.path.exists(os.path.dirname(plan_file_path)):
                os.makedirs(os.path.dirname(plan_file_path))

            with open(plan_file_path, 'w') as plan_file:
                for act in actions:
                    plan_file.write(f'{act}\n')
        except Exception as e:
            print(e)
            if attempt < num_attempts - 1:
                continue
            else:
                actions = "cannot generate plan"
                plan_file_path = f'../../../output/llm-as-ltl-formalizer/{domain}/{data}/generate/{model}/{constraint_type}/{problem}/{problem}_{constraint}_{model}_output.txt'
                if not os.path.exists(os.path.dirname(plan_file_path)):
                    os.makedirs(os.path.dirname(plan_file_path))
                with open(plan_file_path, 'w') as plan_file:
                    plan_file.write(actions)
        break
    return actions



async def run_qwen_batch(engine, domain, data, model, constraint_type, problems, constraints):
    for problem, constraint in zip(problems, constraints):
        print(f'running {problem}_{constraint}')
        try:
            actions = await run_qwen_ltl(engine, domain, data, model, constraint_type, problem, constraint)
        except:
            print(f'cannot run {problem}_{constraint}')

def main(domain, data, model, constraint_type, problems, constraints):
    problem_names, constraint_names = problem_and_constraint_names(problems, constraints)
    engine = HuggingEngine(model_id = f"Qwen/{model}", model_load_kwargs={"device_map": "auto"})
    asyncio.run(run_qwen_batch(engine, domain, data, model, constraint_type, problem_names, constraint_names))

if __name__ == "__main__":
    argparser = argparse.ArgumentParser()
    argparser.add_argument("--domain", type=str, default="coin_collector")
    argparser.add_argument("--data", default="CoinCollector-100_includeDoors0")
    argparser.add_argument("--model", help="which model to use", choices=["Qwen3-32B", "Qwen2.5-Coder-32B-Instruct"])
    argparser.add_argument("--constraint_type", help="which constraint to evaluate", choices=["goal", "action", "state", "baseline"])
    argparser.add_argument("--problems", type=str, required=True, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)", default="21-40")
    argparser.add_argument("--constraints", type=str, required=True, help="Single number, comma-separated list, or range (e.g., 1,3,5 or 1-10)", default="14-33")

    args = argparser.parse_args()

    domain = args.domain
    data = args.data
    model = args.model
    constraint_type = args.constraint_type
    problems = args.problems
    constraints = args.constraints

    main(domain=domain, data=data, model=model, constraint_type=constraint_type, problems=problems, constraints=constraints)

    