# llm-as-formalizer-constraints

**llm-as-formalizer-constraints** consists of datasets and pipelines for using LLMs to generate PDDL and plans when constraints are introduced.

## Requirements
To run the pipeline, the following are needed:
- OpenAI: your OpenAI API key should replace the following line (line 37 in `source/llm-as-formalizer.py` and `source/llm-as-planner.py`):
```
OPENAI_API_KEY = open(f'../../_private/key.txt').read()
```
- Kani: install Kani using the following:
```
pip install "kani[all]" torch 'accelerate>=0.26.0'
```
- bitsandbytes: install bitsandbytes for quantization using the following:
```
pip install transformers accelerate bitsandbytes>0.37.0
```
- VAL: follow [VAL GitHub repository](https://github.com/KCL-Planning/VAL) for instructions to install VAL, then change the following line (line 57 in `source/pipeline/run_val.py`) to the VAL executable:
```
validate_executable = "../../../../../Research/PDDL_Project/VAL/build/macos64/Release/bin/Validate"
```

## Datasets
All datasets can be found in the `/data` folder.

In `/data` the following folders can be found:
- `blocksworld`: datasets for the BlocksWorld domain
    * `BlocksWorld-100`: taken from [Huang and Zhang (2025)](https://github.com/CassieHuang22/llm-as-pddl-formalizer) with added constraints.
    * `BlocksWorld-100-XL`: dataset consisting of BlocksWorld instances where each instance contains 50 blocks
- `mystery_blocksworld`: datasets for the [Mystery BlocksWorld domain](https://arxiv.org/pdf/2206.10498)
    * `Mystery_BlocksWorld-100`: dataset of Mystery BlocksWorld instances. Each instance is a `BlocksWorld-100` instance where the keywords are obfuscated.

Each dataset has the following folders:
- `action_heads`
    * `action_heads.txt`: PDDL action heads for domain when constraints are not introduced
- `constraints`: augmented constraints to the dataset. Each dataset has the following categories:
    * `baseline`: no constraint added, used as baseline
    * `goal`: new goal introduced to problem
    * `initial`: new initial state introduced to problem
    * `numerical`: constraints involving numbers
    * `sequential`: constraints impacting the sequence of actions needed to solve a problem
    * `state-based`: constraints impacting PDDL states and predicates

    Each constraint category contains the following folders:

    * `action_heads`: action_heads file for each problem-constraint pair named `p**_constraint**.txt`. Each file constaints the required action heads for the problem-constraint pair.
    * `constraints`: constraint descriptions for the category, named `constraint**.txt`. Each file constains a natural language description of the constraint and each category contains 20 description files.
    * `pddl`: Groud-truth PDDL for a problem-constraint pair. This folder constains problem folders `p**` where each folder contains two file for each pair, a domain file (`p**_constraint**_df.pddl`) and a problem file (`p**_constraint**_pf.pddl`). There is also a `.jsonl` file that contains information about whether a plan exists for the given problem-constraint pair.

- `descriptions`: non-constrained natural language descriptions of the domain and problem. Each problem consists of a domain description (`p**_domain.txt`) and a problem description (`p**_problem-txt`).
- `pddl`: non-constrainted ground-truth PDDL files for each problem instance. There is one domain file (`domain.pddl`) and 100 problem files (`p**.pddl`) for the 100 problem instances in each dataset.

## LLM-as-Planner
To run the LLM-as-Planner pipeline, run the following:
```
cd source/pipeline
python llm-as-planner.py --domain DOMAIN --data DATA --model MODEL --constraint_type CONSTRAINT_TYPE --default | --problem_start PROBLEM_START --problem_end PROBLEM_END --constraint_start CONSTRAINT_START --constraint_end CONSTRAINT_END
```
where 
- `--domain` is which domain to evaluate (`blocksworld` or `mystery_blocksworld`)
- `--data` is which dataset to use (`BlocksWorld-100`, `Mystery_BlocksWorld-100` or `BlocksWorld-100-XL`)
- `--model` is which model to run (`deepseek-reasoner`, `deepseek-chat`, `Qwen3-32B`, or `Qwen2.5-Coder-32B-Instruct`)
- `--constraint_type` is which constraint category to run (`baseline`, `goal`, `initial`, `numerical`, `sequential`, `state-based`)
- `--default`: indicates to run the default setting (all problems in that constraint category)
- `--problem_start` is which problem index to start running from. This number is inclusive (eg. `1` means starting from `p01`)
- `--problem_end` is which problem index to end running at. This number is exclusive (eg. `101` means stop after finishing `p100`)
- `--constraint_start` is which constraint index to start running from. This number is inclusive (eg. `1` means starting from `constraint1`)
- `--constraint_end` is which constraint index to end running at. This number is exclusive (eg. `21` means stop after finishing `constraint20`)

output will be written in `/output/llm-as-planner/DOMAIN/DATA/MODEL/CONSTRAINT_TYPE`

## LLM-as-PPDL-Formalizer 
### Generate
To generate entire PDDL (without revision), run the following:
```
cd source/pipeline
python pddl_formalizer_generate.py --domain DOMAIN --data DATA --model MODEL --constraint_type CONSTRAINT_TYPE --default | --problem_start PROBLEM_START --problem_end PROBLEM_END --constraint_start CONSTRAINT_START --constraint_end CONSTRAINT_END
```

output will be written in `/output/llm-as-formalizer/DOMAIN/DATA/generate/MODEL/CONSTRAINT_TYPE`

### Edit
To first generate the PDDL without constraints then edit the output to satisfy the new constraint (without revision), run the following:
```
cd source/pipeline
python pddl_formalizer_edit_1.py --domain DOMAIN --data DATA --model MODEL --default | --problem_start PROBLEM_START --problem_end PROBLEM_END
python pddl_formalizer_edit_2.py --domain DOMAIN --data DATA --model MODEL --constraint_type CONSTRAINT_TYPE --default | --problem_start PROBLEM_START --problem_end PROBLEM_END --constraint_start CONSTRAINT_START --constraint_end CONSTRAINT_END
```

output will be written in `/output/llm-as-formalizer/DOMAIN/DATA/edit/MODEL/CONSTRAINT_TYPE`

### Revision
To revise generated PDDL with deepseek models (`deepseek-reasoner` or `deepseek-chat`), run the following:
```
cd source/pipeline
python pddl_formalizer_revision_deepseek.py --domain DOMAIN --data DATA --model MODEL --run_type RUN_TYPE --constraint_type CONSTRAINT_TYPE --solver SOLVER --default | --problem_start PROBLEM_START --problem_end PROBLEM_END --constraint_start CONSTRAINT_START --constraint_end CONSTRAINT_END
```

where
- `--run_type` is which method was used to generate PDDL (`generate` or `edit`)
- `--solver` is which PDDL solver to use for revisions (default is `dual-bfws-ffparser`)

To revise generated PDDL with Qwen models (`Qwen3-32B` or `Qwen2.5-Coder-32B-Instruct`), run the following:
```
cd source/pipeline
python pddl_formalizer_revision_qwen.py --domain DOMAIN --data DATA --model MODEL --run_type RUN_TYPE --constraint_type CONSTRAINT_TYPE --solver SOLVER --default | --problem_start PROBLEM_START --problem_end PROBLEM_END --constraint_start CONSTRAINT_START --constraint_end CONSTRAINT_END
```

output will be written in `/output/llm-as-formalizer/DOMAIN/DATA/revisions/RUN_TYPE/MODEL/CONSTRAINT_TYPE`

### PDDL Solver
After generating the PDDL, we can run the solver using the following:
```
cd source/pipeline
python run_solver.py --domain DOMAIN --data DATA --model MODEL --run_type RUN_TYPE --constraint_type CONSTRAINT_TYPE [--revision] --solver SOLVER --default | --problem_start PROBLEM_START --problem_end PROBLEM_END --constraint_start CONSTRAINT_START --constraint_end CONSTRAINT_END
```
where `--revision` is an optional flag to run the solver for the generated PDDL after revision is introduced.

output will be written as `.txt` in the same folder as the generated PDDL

## Z3 
**TO DO**

## Evaluation
To evaluate the result of LLM-as-PDDL-Formalizer or LLM-as-Planner using VAL, run the following:
```
cd source/pipeline
python run_val.py --domain DOMAIN --data DATA --model MODEL --run_type RUN_TYPE --constraint_type CONSTRAINT_TYPE --prediction_type PREDICTION_TYPE [--revision] --default | --problem_start PROBLEM_START --problem_end PROBLEM_END --constraint_start CONSTRAINT_START --constraint_end CONSTRAINT_END [--csv_result]
```
where 
- `--prediction_type` is which pipeline to use (`llm-as-formalizer` or  `llm-as-planner`).
- `--csv_result` is an optional flag that outputs all results (plans and errors) in a csv file.

VAL output will be written as `.txt` in the same folder as the generated PDDL. Correctness and number of syntax errors will be printed in the terminal. Optional csv file will be saved to directory containing all constraint categories (`edit`, `generate`, `revisions/generate` or `revisions/edit`).

