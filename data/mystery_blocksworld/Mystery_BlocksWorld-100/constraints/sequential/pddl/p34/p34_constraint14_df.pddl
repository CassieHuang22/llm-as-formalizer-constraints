(define (domain mystery_blocksworld)
;; CONSTRAINT For every second set of actions, you must perform a set of actions on an object with a number that is a multiple of 4.
  (:requirements :strips)
  (:predicates
    (predicate5 ?x ?y)      
    (predicate2 ?x)          
    (predicate1 ?x)            
    (predicate3)                  
    (predicate4 ?x)         
;; BEGIN ADD
    (mult-4 ?x) (not-mult-4 ?x)
    (last-not-mult-4)  (last-mult-4)  (last-none)
;; END ADD
  )

  (:action action1
    :parameters (?b)
    :precondition (and (predicate2 ?b) (predicate1 ?b) (predicate3)
;; BEGIN ADD
    (or (and (not-mult-4 ?b) (or (last-none) (last-mult-4))) (and (mult-4 ?b) (last-not-mult-4)))
;; END ADD
                       )
    :effect (and (predicate4 ?b)
                 (not (predicate2 ?b))
                 (not (predicate3))
;; BEGIN ADD
                 (when (not-mult-4 ?b) (and (last-not-mult-4) (not (last-mult-4)) (not (last-none))))
                 (when (mult-4 ?b) (and (last-mult-4) (not (last-not-mult-4)) (not (last-none))))
;; END ADD
    )
  )

  (:action action4
    :parameters (?b ?c)
    :precondition (and (predicate5 ?b ?c) (predicate1 ?b) (predicate3)
;; BEGIN ADD
    (or (and (not-mult-4 ?b) (or (last-none) (last-mult-4))) (and (mult-4 ?b) (last-not-mult-4)))
;; END ADD 
                       )
    :effect (and (predicate4 ?b)
                 (predicate1 ?c)
                 (not (predicate5 ?b ?c))
                 (not (predicate3))
;; BEGIN ADD
                 (when (not-mult-4 ?b) (and (last-not-mult-4) (not (last-mult-4)) (not (last-none))))
                 (when (mult-4 ?b) (and (last-mult-4) (not (last-not-mult-4)) (not (last-none))))
;; END ADD          
                 )
  )

  (:action action2
    :parameters (?b)
;; BEGIN EDIT
    :precondition (and (predicate4 ?b) (or (mult-4 ?b) (not-mult-4 ?b)))
;; END EDIT
    :effect (and (predicate2 ?b) (predicate1 ?b)
                 (predicate3) (not (predicate4 ?b)))
  )

  (:action action3
    :parameters (?b ?c)
    :precondition (and (predicate4 ?b) (predicate1 ?c)
;; BEGIN ADD
    (or (mult-4 ?b) (not-mult-4 ?b))
;; END ADD
    )
    :effect (and (predicate5 ?b ?c) (predicate1 ?b)
                 (predicate3) (not (predicate4 ?b)))
  )
)
