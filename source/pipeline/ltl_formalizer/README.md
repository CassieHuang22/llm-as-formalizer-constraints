## Setup the environment

1. Install [`spot`](https://spot.lre.epita.fr/install.html) library for LTL support. An easy way is to install it through conda, by
```
conda install -c conda-forge spot
```
2. install `openai` dependency for prompting by `pip install openai` or conda again.

## Run Scripts

1. Before running, export your openai key by `export OPENAI_API_KEY={YOUR_OPENAI_KEY}`
2. `ltl_to_plan.py` contains all functions supporting LTL-based planning for coincolelctor. At the same time, it also contains an example problem as a sanity checker, and the LTL formulas are copied from language model's output. To try the test run, simply run it from anywhere, and the results will be printed out.
3. `ltl_formalizer.py` import all necessary functions from the previous file and `utils.py`. It prompts the language model with the prompts in `ltl_prompt.yaml`, get problem LTL, constraint LTL, and rooms adjacency, and then output the final plan in a sequence of PDDL-style actions. YOu can still simply run this file as is from anywhere.
4. Both files use the same example: domain from `p100`, constraint is `If you take the coin, you must go to the kitchen directly after.`