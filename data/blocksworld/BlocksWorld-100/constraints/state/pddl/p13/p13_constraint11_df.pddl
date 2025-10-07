(define (domain blocksworld)
;; CONSTRAINT Once you start moving blocks, you must have no more than 2 stacks at any time.
  (:requirements :strips :typing)
;; BEGIN EDIT
  (:types block slot)  

  (:predicates
        (on        ?x - block ?y - block)
        (on-table  ?x - block)
        (clear     ?x - block)
        (holding   ?x - block)
        (arm-empty)
;; BEGIN ADD
        (free ?s - slot)                 
        (in-slot ?b - block ?s - slot)
;; END ADD
        )  
;; BEGIN EDIT                                      
  (:action pickup
     :parameters (?b - block ?s - slot)
     :precondition (and (on-table ?b) (clear ?b) (arm-empty)
                        (in-slot ?b ?s))
     :effect (and (holding ?b)
                  (not (on-table ?b))
                  (not (arm-empty))
                  (not (in-slot ?b ?s))
                  (free ?s))
  )
;; END EDIT

  (:action unstack
     :parameters (?top - block ?below - block)
     :precondition (and (on ?top ?below) (clear ?top) (arm-empty))
     :effect (and (holding ?top)
                  (clear ?below)
                  (not (on ?top ?below))
                  (not (clear ?top))
                  (not (arm-empty)))
  )

;; BEGIN EDIT
  (:action putdown
     :parameters (?b - block ?s - slot)
     :precondition (and (holding ?b) (free ?s))
     :effect (and (on-table ?b) (clear ?b)
                  (arm-empty) (not (holding ?b))
                  (in-slot ?b ?s)
                  (not (free ?s)))
  )
;; END EDIT

  (:action stack
     :parameters (?top - block ?below - block)
     :precondition (and (holding ?top) (clear ?below))
     :effect (and (on ?top ?below)
                  (clear ?top)
                  (arm-empty)
                  (not (holding ?top))
                  (not (clear ?below)))
  )
)