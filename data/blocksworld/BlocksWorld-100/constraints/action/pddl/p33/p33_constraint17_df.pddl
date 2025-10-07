(define (domain blocksworld)
;; CONSTRAINT For every second move, you must move a block with a number that is a multiple of 3.
  (:requirements :strips)
  (:predicates
    (on ?x ?y)      
    (on-table ?x)          
    (clear ?x)            
    (arm-empty)                  
    (holding ?x)         
;; BEGIN ADD
    (mult-3 ?x) (not-mult-3 ?x)
    (last-not-mult-3)  (last-mult-3)  (last-none)
;; END ADD
  )

  (:action pickup
    :parameters (?b)
    :precondition (and (on-table ?b) (clear ?b) (arm-empty)
;; BEGIN ADD
    (or (and (not-mult-3 ?b) (or (last-none) (last-mult-3))) (and (mult-3 ?b) (last-not-mult-3)))
;; END ADD
                       )
    :effect (and (holding ?b)
                 (not (on-table ?b))
                 (not (arm-empty))
;; BEGIN ADD
                 (when (not-mult-3 ?b) (and (last-not-mult-3) (not (last-mult-3)) (not (last-none))))
                 (when (mult-3 ?b) (and (last-mult-3) (not (last-not-mult-3)) (not (last-none))))
;; END ADD
    )
  )

  (:action unstack
    :parameters (?b ?c)
    :precondition (and (on ?b ?c) (clear ?b) (arm-empty)
;; BEGIN ADD
    (or (and (not-mult-3 ?b) (or (last-none) (last-mult-3))) (and (mult-3 ?b) (last-not-mult-3)))
;; END ADD 
                       )
    :effect (and (holding ?b)
                 (clear ?c)
                 (not (on ?b ?c))
                 (not (arm-empty))
;; BEGIN ADD
                 (when (not-mult-3 ?b) (and (last-not-mult-3) (not (last-mult-3)) (not (last-none))))
                 (when (mult-3 ?b) (and (last-mult-3) (not (last-not-mult-3)) (not (last-none))))
;; END ADD          
                 )
  )

  (:action putdown
    :parameters (?b)
;; BEGIN EDIT
    :precondition (and (holding ?b) (or (mult-3 ?b) (not-mult-3 ?b)))
;; END EDIT
    :effect (and (on-table ?b) (clear ?b)
                 (arm-empty) (not (holding ?b)))
  )

  (:action stack
    :parameters (?b ?c)
    :precondition (and (holding ?b) (clear ?c)
;; BEGIN ADD
    (or (mult-3 ?b) (not-mult-3 ?b))
;; END ADD
    )
    :effect (and (on ?b ?c) (clear ?b)
                 (arm-empty) (not (holding ?b)))
  )
)
