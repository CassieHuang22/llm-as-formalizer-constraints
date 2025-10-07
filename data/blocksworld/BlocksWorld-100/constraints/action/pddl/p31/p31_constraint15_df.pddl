(define (domain blocksworld)
;; CONSTRAINT You must alternate between moving even numbered blocks and odd numbered blocks in each move.
  (:requirements :strips)
  (:predicates
    (on ?x ?y)      
    (on-table ?x)          
    (clear ?x)            
    (arm-empty)                  
    (holding ?x)         
;; BEGIN ADD
    (even ?x) (odd ?x)
    (last-odd)  (last-even)  (last-none)
;; END ADD
  )

  (:action pickup
    :parameters (?b)
    :precondition (and (on-table ?b) (clear ?b) (arm-empty)
;; BEGIN ADD
    (or (and (odd ?b) (or (last-none) (last-even))) (and (even ?b) (or (last-none) (last-odd))))
;; END ADD
                       )
    :effect (and (holding ?b)
                 (not (on-table ?b))
                 (not (arm-empty))
;; BEGIN ADD
                 (when (odd ?b) (and (last-odd) (not (last-even)) (not (last-none))))
                 (when (even ?b) (and (last-even) (not (last-odd)) (not (last-none))))
;; END ADD
    )
  )

  (:action unstack
    :parameters (?b ?c)
    :precondition (and (on ?b ?c) (clear ?b) (arm-empty)
;; BEGIN ADD
    (or (and (odd ?b) (or (last-none) (last-even))) (and (even ?b) (or (last-none) (last-odd))))
;; END ADD 
                       )
    :effect (and (holding ?b)
                 (clear ?c)
                 (not (on ?b ?c))
                 (not (arm-empty))
;; BEGIN ADD
                 (when (odd ?b) (and (last-odd) (not (last-even)) (not (last-none))))
                 (when (even ?b) (and (last-even) (not (last-odd)) (not (last-none))))
;; END ADD          
                 )
  )

  (:action putdown
    :parameters (?b)
;; BEGIN EDIT
    :precondition (and (holding ?b) (or (even ?b) (odd ?b)))
;; END EDIT
    :effect (and (on-table ?b) (clear ?b)
                 (arm-empty) (not (holding ?b)))
  )

  (:action stack
    :parameters (?b ?c)
    :precondition (and (holding ?b) (clear ?c)
;; BEGIN ADD
    (or (even ?b) (odd ?b))
;; END ADD
    )
    :effect (and (on ?b ?c) (clear ?b)
                 (arm-empty) (not (holding ?b)))
  )
)
