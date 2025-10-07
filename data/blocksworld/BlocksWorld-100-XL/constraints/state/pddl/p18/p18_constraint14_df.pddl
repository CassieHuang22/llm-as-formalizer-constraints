(define (domain blocksworld)
;; CONSTRAINT Once you start moving blocks, you must have exactly 4 stacks at any time.
;; BEGIN EDIT
  (:requirements :strips :typing)
;; END EDIT
;; BEGIN ADD
  (:types block stackpos)
;; END ADD
  (:predicates
    (clear ?x - block)
    (on ?x - block ?y - block)
    (on-table ?x - block)
    (holding ?x - block)
    (arm-empty)
;; BEGIN ADD
    (assigned ?b - block ?s - stackpos)
    (used ?s - stackpos)
;; END ADD
  )

  (:action pickup
;; BEGIN EDIT
    :parameters (?b - block ?s - stackpos)
;; END EDIT
    :precondition (and (clear ?b) (on-table ?b) (arm-empty) 
;; BEGIN ADD
    (assigned ?b ?s)
;; END ADD
    )
    :effect (and (holding ?b)
                 (not (on-table ?b))
                 (not (arm-empty))
;; BEGIN ADD
                 (not (assigned ?b ?s))
                 (not (used ?s))
;; END ADD
                 )
  )

  (:action unstack
;; BEGIN EDIT
    :parameters (?b - block ?x - block ?s - stackpos)
;; END EDIT
    :precondition (and (on ?b ?x) (clear ?b) (arm-empty) 
;; BEGIN ADD
    (assigned ?b ?s)
;; END ADD 
    )
    :effect (and (holding ?b)
                 (clear ?x)
                 (not (on ?b ?x))
;; BEGIN ADD
                 (not (assigned ?b ?s))
;; END ADD
                 (not (arm-empty)))
  )

  (:action stack
;; BEGIN EDIT
    :parameters (?b - block ?x - block ?s - stackpos)
;; END EDIT
    :precondition (and (holding ?b) (clear ?x) 
;; BEGIN ADD
    (assigned ?x ?s)
;; END ADD
    )
    :effect (and (on ?b ?x)
                 (clear ?b)
                 (arm-empty)
;; BEGIN ADD
                 (assigned ?b ?s)
;; END ADD
                 (not (holding ?b)))
  )

  (:action putdown
;; BEGIN EDIT
    :parameters (?b - block ?s - stackpos)
    :precondition (and (holding ?b) (not (used ?s)))
;; END EDIT
    :effect (and (on-table ?b)
                 (clear ?b)
                 (arm-empty)
;; BEGIN ADD
                 (assigned ?b ?s)
                 (used ?s)
;; END ADD
                 (not (holding ?b)))
  )
)
