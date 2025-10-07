"""source code for planning with LTL formulas using Spot library. Works for coincollector only."""

from collections import deque
import argparse

import spot

def ltl_to_plan(phi: str, adjacency: dict, debug=False):
    """Get PDDL-styple plan from an LTL formula and room adjacency."""

    if debug:
        print("LTL formula:", phi)
        print("Adjacency:", adjacency)
        print("\n")

    # Translate to automaton
    aut = spot.translate(phi)

    # Find an accepting lasso run
    lasso = find_lasso(aut)
    if lasso:
        prefix, cycle = lasso
        print("Prefix:", prefix)
        print("Cycle:", cycle)
        print("\n")
    else:
        print("No accepting lasso found. Something is wrong.")
        return []

    prefix_labels = run_to_labels(aut, prefix)
    cycle_labels  = run_to_labels(aut, cycle) # just in case
    if debug:
        print("Prefix labels:", prefix_labels)
        print("Cycle labels:", cycle_labels)
        print("\n")

    # Map back to actions
    actions = labels_to_actions(prefix_labels, adjacency)
    if debug:
        print("Inferred actions:", actions)
        print("\n")

    return actions

def find_lasso(aut: spot.twa):
    """Find one accepting lasso run in a Spot automaton."""
    def state_has_accepting_edge(aut, state):
        for e in aut.out(state):
            if e.acc.count() > 0:   # nonempty acceptance set
                return True
        return False
    def cycle_contains_accepting_edge(aut, cycle):
        """Return True if the cycle path uses at least one accepting edge."""
        for i in range(len(cycle)-1):
            src, dst = cycle[i], cycle[i+1]
            for e in aut.out(src):
                if e.dst == dst and e.acc.count() > 0:
                    return True
        return False

    start = aut.get_init_state_number()

    # Step 1: reach accepting state
    q = deque([(start, [])])
    visited = set()
    accepting_state = None
    prefix = []

    while q and accepting_state is None:
        state, path = q.popleft()
        if state in visited:
            continue
        visited.add(state)
        for e in aut.out(state):
            new_path = path + [state]
            if e.acc.count() > 0:
                accepting_state = e.dst
                prefix = new_path + [e.dst]
                break
            q.append((e.dst, new_path))

    if accepting_state is None:
        return None

    # Step 2: search cycle from accepting state
    q = deque([(accepting_state, [accepting_state])])
    visited = set()
    while q:
        state, path = q.popleft()
        if state in visited:
            continue
        visited.add(state)
        for e in aut.out(state):
            new_path = path + [e.dst]
            if e.dst == accepting_state:
                if cycle_contains_accepting_edge(aut, new_path):
                    return prefix, new_path
            q.append((e.dst, new_path))

    return None

def run_to_labels(aut: spot.twa, run_states):
    """Convert a run (list of automaton states) into a list of edge labels (as strings)."""
    labels = []
    for src, dst in zip(run_states, run_states[1:]):
        found = False
        for edge in aut.out(src):
            if edge.dst == dst:
                labels.append(spot.bdd_format_formula(aut.get_dict(), edge.cond))
                found = True
                break
        assert found, f"No edge from {src} to {dst} in automaton"
    return labels

def infer_action(prev_label, next_label, adjacency):
    """Infer action from two consecutive states in the run."""
    def parse_label(label: str):
        # Extract the literal(s) that are positive
        lits = [tok for tok in label.replace(" ", "").split("&") if not tok.startswith("!")]
        return set(lits)
    
    prev_true = parse_label(prev_label)
    next_true = parse_label(next_label)

    if len(prev_true) == len(next_true) and prev_true != next_true: # action is move
        common = prev_true & next_true
        prev_true = prev_true - common
        next_true = next_true - common
        src = list(prev_true)[0]
        dst = list(next_true)[0]
        return f"(move {src.lower()} {dst.lower()} {adjacency[src.lower()][dst.lower()]})"
    
    elif len(prev_true) == 1 and len(next_true) == 2: # action is take coin

        src = list(prev_true)[0]
        return f"(take coin {src.lower()})"
    print("Could not infer action from labels:", prev_label, "->", next_label)
    return None

def labels_to_actions(labels, adjacency):
    actions = []
    for prev, nxt in zip(labels, labels[1:]):
        act = infer_action(prev, nxt, adjacency)
        if act:
            actions.append(act)
    return actions

if __name__ == "__main__":
    # This argparse is just a placeholder in case we want to debug with stored LTL formulas
    parser = argparse.ArgumentParser()


    # # Test case#1:
    # #   four rooms: kitchen, living room, bedroom, and bathroom center around a corridor
    # #   agent starts in corridor
    # #   coin is in kitchen

    # adjacency = {
    #     "corridor": {"kitchen": "north", "living_room": "south", "bedroom": "east", "bathroom": "west"},
    #     "kitchen": {"corridor": "south"},
    #     "living_room": {"corridor": "north"},
    #     "bedroom": {"corridor": "west"},
    #     "bathroom": {"corridor": "east"},
    # }

    # # Occupancy: exactly one room at a time
    # rooms = list(adjacency.keys())
    # at_least_one = "G(" + " | ".join(rooms) + ")"
    # pairs = []
    # for i in range(len(rooms)):
    #     for j in range(i+1, len(rooms)):
    #         pairs.append(f"G(!( {rooms[i]} & {rooms[j]} ))")
    # at_most_one = " & ".join(pairs)
    # occupancy = f"({at_least_one}) & ({at_most_one})"

    # # Dynamics: allowed moves
    # dynamics = (
    #     "G(corridor -> X(kitchen | living_room | bedroom | bathroom)) & "
    #     "G(kitchen -> X corridor) & "
    #     "G(living_room -> X corridor) & "
    #     "G(bedroom -> X corridor) & "
    #     "G(bathroom -> X corridor) & "
    #     "G( (bedroom & !has_coin) -> X(has_coin | !has_coin) ) &"
    #     "G( (!bedroom & !has_coin) -> X(!has_coin) )"
    # )

    # # Initial condition
    # init = "corridor & ! has_coin"

    # # Task
    # goal = "F has_coin"

    # # Whole formula
    # phi = f"({init}) & ({occupancy}) & ({dynamics}) & ({goal})"

    # actions = ltl_to_plan(phi, adjacency, debug=True)
    # print("----------------------------------------------------")
    # print("Final plan:")
    # for act in actions:
    #     print(" ", act)

    #############################################################
    # Test case 2: coincollector with constraint
    #   Problem: No.100
    #   Constraint: If you take the coin, you must go to the kitchen directly after.
    #############################################################

    adjacency = {
    "kitchen": {"pantry": "north", "living_room": "west"},
    "pantry": {"kitchen": "south"},
    "living_room": {"kitchen": "east", "backyard": "south", "bathroom": "west"},
    "backyard": {"living_room": "north", "street": "east", "corridor": "west"},
    "street": {"backyard": "west", "supermarket": "east"},
    "corridor": {"backyard": "east", "bathroom": "north", "driveway": "south", "bedroom": "west"},
    "bathroom": {"living_room": "east", "corridor": "south", "laundry_room": "west"},
    "laundry_room": {"bathroom": "east"},
    "supermarket": {"street": "west"},
    "driveway": {"corridor": "north"},
    "bedroom": {"corridor": "east"}
    }
    
    init = "kitchen & !has_coin"

    occupancy = """G( (kitchen | pantry | living_room | backyard | bathroom | street | corridor | laundry_room | supermarket | driveway | bedroom) 
    & !(kitchen & pantry) & !(kitchen & living_room) & !(kitchen & backyard) & !(kitchen & bathroom) & !(kitchen & street) & !(kitchen & corridor) & !(kitchen & laundry_room) & !(kitchen & supermarket) & !(kitchen & driveway) & !(kitchen & bedroom) 
    & !(pantry & living_room) & !(pantry & backyard) & !(pantry & bathroom) & !(pantry & street) & !(pantry & corridor) & !(pantry & laundry_room) & !(pantry & supermarket) & !(pantry & driveway) & !(pantry & bedroom) 
    & !(living_room & backyard) & !(living_room & bathroom) & !(living_room & street) & !(living_room & corridor) & !(living_room & laundry_room) & !(living_room & supermarket) & !(living_room & driveway) & !(living_room & bedroom) 
    & !(backyard & bathroom) & !(backyard & street) & !(backyard & corridor) & !(backyard & laundry_room) & !(backyard & supermarket) & !(backyard & driveway) & !(backyard & bedroom) 
    & !(bathroom & street) & !(bathroom & corridor) & !(bathroom & laundry_room) & !(bathroom & supermarket) & !(bathroom & driveway) & !(bathroom & bedroom) 
    & !(street & corridor) & !(street & laundry_room) & !(street & supermarket) & !(street & driveway) & !(street & bedroom) 
    & !(corridor & laundry_room) & !(corridor & supermarket) & !(corridor & driveway) & !(corridor & bedroom) 
    & !(laundry_room & supermarket) & !(laundry_room & driveway) & !(laundry_room & bedroom) 
    & !(supermarket & driveway) & !(supermarket & bedroom) 
    & !(driveway & bedroom) )"""

    move_dynamics = "G( kitchen -> X( kitchen | pantry | living_room ) ) \
    & G( pantry -> X( pantry | kitchen ) ) \
    & G( living_room -> X( living_room | kitchen | backyard | bathroom ) ) \
    & G( backyard -> X( backyard | living_room | street | corridor ) ) \
    & G( bathroom -> X( bathroom | living_room | corridor | laundry_room ) ) \
    & G( street -> X( street | backyard | supermarket ) ) \
    & G( corridor -> X( corridor | backyard | bathroom | driveway | bedroom ) ) \
    & G( laundry_room -> X( laundry_room | bathroom ) ) \
    & G( supermarket -> X( supermarket | street ) ) \
    & G( driveway -> X( driveway | corridor ) ) \
    & G( bedroom -> X( bedroom | corridor ) )"

    pickup_dynamics = "G( (pantry & !has_coin) -> X( has_coin | !has_coin ) ) \
    & G( (!pantry & !has_coin) -> X( !has_coin ) )\
    & G(has_coin -> X(has_coin)) \
    & G( (pantry & !has_coin & X has_coin) -> X pantry )"

    goal = "F(has_coin)"

    constraint = "G((!has_coin & X(has_coin))->XX(kitchen))"
    # constraint = "G(has_coin -> F(kitchen))"  # a bit looser

    phi = f"({init}) & ({occupancy}) & ({move_dynamics}) & ({pickup_dynamics}) & ({goal}) & ({constraint})"

    actions = ltl_to_plan(phi, adjacency, debug=True)
    print("----------------------------------------------------")
    print("Final plan:")
    for act in actions:
        print(" ", act)


