(define (domain blocksworld)
;; CONSTRAINT For every second move, you must move a block with a number that is a multiple of 5.
  (:requirements :strips)
  (:predicates
    (on ?x ?y)      
    (on-table ?x)          
    (clear ?x)            
    (arm-empty)                  
    (holding ?x)         
;; BEGIN ADD
    (mult-5 ?x) (not-mult-5 ?x)
    (last-not-mult-5)  (last-mult-5)  (last-none)
;; END ADD
  )

  (:action pickup
    :parameters (?b)
    :precondition (and (on-table ?b) (clear ?b) (arm-empty)
;; BEGIN ADD
    (or (and (not-mult-5 ?b) (or (last-none) (last-mult-5))) (and (mult-5 ?b) (last-not-mult-5)))
;; END ADD
                       )
    :effect (and (holding ?b)
                 (not (on-table ?b))
                 (not (arm-empty))
;; BEGIN ADD
                 (when (not-mult-5 ?b) (and (last-not-mult-5) (not (last-mult-5)) (not (last-none))))
                 (when (mult-5 ?b) (and (last-mult-5) (not (last-not-mult-5)) (not (last-none))))
;; END ADD
    )
  )

  (:action unstack
    :parameters (?b ?c)
    :precondition (and (on ?b ?c) (clear ?b) (arm-empty)
;; BEGIN ADD
    (or (and (not-mult-5 ?b) (or (last-none) (last-mult-5))) (and (mult-5 ?b) (last-not-mult-5)))
;; END ADD 
                       )
    :effect (and (holding ?b)
                 (clear ?c)
                 (not (on ?b ?c))
                 (not (arm-empty))
;; BEGIN ADD
                 (when (not-mult-5 ?b) (and (last-not-mult-5) (not (last-mult-5)) (not (last-none))))
                 (when (mult-5 ?b) (and (last-mult-5) (not (last-not-mult-5)) (not (last-none))))
;; END ADD          
                 )
  )

  (:action putdown
    :parameters (?b)
;; BEGIN EDIT
    :precondition (and (holding ?b) (or (mult-5 ?b) (not-mult-5 ?b)))
;; END EDIT
    :effect (and (on-table ?b) (clear ?b)
                 (arm-empty) (not (holding ?b)))
  )

  (:action stack
    :parameters (?b ?c)
    :precondition (and (holding ?b) (clear ?c)
;; BEGIN ADD
    (or (mult-5 ?b) (not-mult-5 ?b))
;; END ADD
    )
    :effect (and (on ?b ?c) (clear ?b)
                 (arm-empty) (not (holding ?b)))
  )
)
