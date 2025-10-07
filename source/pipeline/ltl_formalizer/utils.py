"""utility functions for ltl formalizer"""
import json
import yaml
import os
import base64
from openai import OpenAI
from kani import Kani
from kani.engines.huggingface import HuggingEngine

def load_from_file(fpath, noheader=True):
    ftype = os.path.splitext(fpath)[-1][1:]
    if ftype == 'txt':
        with open(fpath, 'r') as rfile:
            if 'prompt' in fpath:
                out = "".join(rfile.readlines())
            else:
                out = [line.strip() for line in rfile.readlines()]
    elif ftype == 'json':
        with open(fpath, 'r') as rfile:
            out = json.load(rfile)
    elif ftype == 'yaml':
        with open(fpath, 'r') as rfile:
            out = yaml.load(rfile, Loader=yaml.FullLoader)
    else:
        raise ValueError(f"ERROR: file type {ftype} not recognized")
    return out

def save_to_file(data, fpth, mode=None):
    ftype = os.path.splitext(fpth)[-1][1:]
    if ftype == 'txt':
        with open(fpth, mode if mode else 'w') as wfile:
            wfile.write(data)
    elif ftype == 'json':
        with open(fpth, mode if mode else 'w') as wfile:
            json.dump(data, wfile, sort_keys=True,  indent=4)
    elif ftype == 'yaml':
        with open(fpth, 'w') as wfile:
            yaml.dump(data, wfile)
    else:
        raise ValueError(f"ERROR: file type {ftype} not recognized")

def raw_prompt_deepseek(prompt, img_path_list=[], model="gpt-5", log=False):
    api_key = open(f'../../../../../_private/key_deepseek.txt').read()
    client = OpenAI(api_key=api_key, base_url="https://api.deepseek.com")

    content = [{"type": "text", "text": prompt}]

    for image_path in img_path_list:
        with open(image_path, "rb") as f:
            image_bytes = f.read()
        base64_image = base64.b64encode(image_bytes).decode("utf-8")
        content.append(
            {
                "type": "image_url",
                "image_url": {
                    "url": f"data:image/png;base64,{base64_image}"
                },
            }
        )

    response = client.chat.completions.create(
        model=model,
        messages=[
                {
                    "role": "user",
                    "content": content
                }
            ],
        )
    if log:
        print(response.choices[0].message.content)
    return response.choices[0].message.content

async def raw_prompt_qwen(engine, prompt):
    ai = Kani(engine, system_prompt="")
    response = await ai.chat_round_str(prompt)
    return response