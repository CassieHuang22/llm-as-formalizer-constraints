(define (domain blocksworld)
;; CONSTRAINT Only 5 block pick ups are allowed in the entire task.
  (:requirements :strips :typing)
;; BEGIN EDIT
  (:types block token)
;; END EDIT
  (:predicates
        (on ?x - block ?y - block)
        (on-table  ?x - block)
        (clear     ?x - block)
        (holding   ?x - block)
        (arm-empty)
;; BEGIN ADD
        (unused ?t - token)
;; END ADD
        )

  (:action pickup
;; BEGIN EDIT
     :parameters (?b - block ?tok - token)
;; END EDIT
     :precondition (and (on-table ?b) (clear ?b) (arm-empty)
;; BEGIN ADD
                   (unused ?tok)
;; END ADD        
                    )    
     :effect (and (holding ?b)
                  (not (on-table ?b))
                  (not (arm-empty))
;; BEGIN ADD
                  (not (unused ?tok))
;; END ADD
                  )          ; token spent
  )

  (:action unstack
     :parameters (?top - block ?below - block)
     :precondition (and (on ?top ?below) (clear ?top) (arm-empty))
     :effect (and (holding ?top)
                  (clear ?below)
                  (not (on ?top ?below))
                  (not (clear ?top))
                  (not (arm-empty)))
  )

  (:action putdown
     :parameters (?b - block)
     :precondition (holding ?b)
     :effect (and (on-table ?b) (clear ?b)
                  (arm-empty)
                  (not (holding ?b)))
  )

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