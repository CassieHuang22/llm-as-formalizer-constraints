(define (domain blocksworld)
;; CONSTRAINT Once you start moving blocks, you must have no more than 1 stacks at any time.
  (:requirements :strips)
  (:predicates
        (on ?x ?y)
        (on-table ?x)
        (clear ?x)
        (holding ?x)
        (arm-empty)
;; BEGIN ADD
        (table-occupied)
;; END ADD
        )

  (:action pickup
     :parameters (?b)
     :precondition (and (on-table ?b) (clear ?b) (arm-empty)
;; BEGIN ADD
                        (table-occupied)
;; END ADD
     )
     :effect (and (holding ?b)
                  (not (on-table ?b))
                  (not (clear ?b))
                  (not (arm-empty))
;; BEGIN ADD
                  (not (table-occupied))
;; END ADD
     )
  )

  (:action unstack
     :parameters (?top ?below)
     :precondition (and (on ?top ?below) (clear ?top) (arm-empty))
     :effect (and (holding ?top)
                  (clear ?below)
                  (not (on ?top ?below))
                  (not (clear ?top))
                  (not (arm-empty)))
  )

  (:action putdown
     :parameters (?b)
;; BEGIN EDIT
     :precondition (and (holding ?b)
                        (not (table-occupied)))   
;; END EDIT
     :effect (and (on-table ?b) (clear ?b)
                  (arm-empty) (not (holding ?b))
;; BEGIN ADD
                  (table-occupied)
;; END ADD
     )
  )

  (:action stack
     :parameters (?top ?below)
     :precondition (and (holding ?top) (clear ?below))
     :effect (and (on ?top ?below)
                  (clear ?top)
                  (arm-empty)
                  (not (holding ?top))
                  (not (clear ?below)))
  )
)