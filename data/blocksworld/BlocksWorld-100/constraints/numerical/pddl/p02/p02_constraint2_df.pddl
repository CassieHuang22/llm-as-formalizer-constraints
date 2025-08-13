(define (domain blocksworld)
;; CONSTRAINT The higher number the block, the heavier it is. Once you start moving blocks, do not stack lighter blocks on heavier blocks.
  (:requirements :strips )
  (:predicates
    (on ?x ?y)
    (on-table ?x)
    (clear ?x)
    (arm-empty)
    (holding ?x)
;; BEGIN ADD
    (lighter ?b ?c)
;; END ADD
  )

  (:action pickup
    :parameters (?b)
    :precondition (and (clear ?b) (on-table ?b) (arm-empty))
    :effect (and (not (on-table ?b))
                 (not (clear ?b))
                 (not (arm-empty))
                 (holding ?b))
  )

  (:action unstack
    :parameters (?b ?c)
    :precondition (and (on ?b ?c) (clear ?b) (arm-empty))
    :effect (and (not (on ?b ?c))
                 (clear ?c)
                 (not (clear ?b))
                 (not (arm-empty))
                 (holding ?b))
  )

  (:action putdown
    :parameters (?b)
    :precondition (holding ?b)
    :effect (and (on-table ?b)
                 (clear ?b)
                 (arm-empty)
                 (not (holding ?b)))
  )

  (:action stack
    :parameters (?b ?c)
    :precondition (and (holding ?b) (clear ?c)
;; BEGIN ADD
                       (not (lighter ?b ?c)))
;; END ADD
    :effect (and (not (holding ?b))
                 (not (clear ?c))
                 (on ?b ?c)
                 (clear ?b)
                 (arm-empty))
  )
)
