(define (domain mystery_blocksworld)
;; CONSTRAINT For every second set of actions, you must perform a set of actions on an object with a number that is a multiple of 3.
  (:requirements :strips)
  (:predicates
    (predicate5 ?x ?y)      
    (predicate2 ?x)          
    (predicate1 ?x)            
    (predicate3)                  
    (predicate4 ?x)         
;; BEGIN ADD
    (mult-3 ?x) (not-mult-3 ?x)
    (last-not-mult-3)  (last-mult-3)  (last-none)
;; END ADD
  )

  (:action action1
    :parameters (?b)
    :precondition (and (predicate2 ?b) (predicate1 ?b) (predicate3)
;; BEGIN ADD
    (or (and (not-mult-3 ?b) (or (last-none) (last-mult-3))) (and (mult-3 ?b) (last-not-mult-3)))
;; END ADD
                       )
    :effect (and (predicate4 ?b)
                 (not (predicate2 ?b))
                 (not (predicate3))
;; BEGIN ADD
                 (when (not-mult-3 ?b) (and (last-not-mult-3) (not (last-mult-3)) (not (last-none))))
                 (when (mult-3 ?b) (and (last-mult-3) (not (last-not-mult-3)) (not (last-none))))
;; END ADD
    )
  )

  (:action action4
    :parameters (?b ?c)
    :precondition (and (predicate5 ?b ?c) (predicate1 ?b) (predicate3)
;; BEGIN ADD
    (or (and (not-mult-3 ?b) (or (last-none) (last-mult-3))) (and (mult-3 ?b) (last-not-mult-3)))
;; END ADD 
                       )
    :effect (and (predicate4 ?b)
                 (predicate1 ?c)
                 (not (predicate5 ?b ?c))
                 (not (predicate3))
;; BEGIN ADD
                 (when (not-mult-3 ?b) (and (last-not-mult-3) (not (last-mult-3)) (not (last-none))))
                 (when (mult-3 ?b) (and (last-mult-3) (not (last-not-mult-3)) (not (last-none))))
;; END ADD          
                 )
  )

  (:action action2
    :parameters (?b)
;; BEGIN EDIT
    :precondition (and (predicate4 ?b) (or (mult-3 ?b) (not-mult-3 ?b)))
;; END EDIT
    :effect (and (predicate2 ?b) (predicate1 ?b)
                 (predicate3) (not (predicate4 ?b)))
  )

  (:action action3
    :parameters (?b ?c)
    :precondition (and (predicate4 ?b) (predicate1 ?c)
;; BEGIN ADD
    (or (mult-3 ?b) (not-mult-3 ?b))
;; END ADD
    )
    :effect (and (predicate5 ?b ?c) (predicate1 ?b)
                 (predicate3) (not (predicate4 ?b)))
  )
)
