(define (domain mystery_blocksworld)
;; CONSTRAINT You must start by performing a set of actions on an odd numbered object, then alternate between performing sets of actions on even numbered objects and odd numbered objects.
  (:requirements :strips)
  (:predicates
    (predicate5 ?x ?y)      
    (predicate2 ?x)          
    (predicate1 ?x)            
    (predicate3)                  
    (predicate4 ?x)         
;; BEGIN ADD
    (even ?x) (odd ?x)
    (last-odd)  (last-even)  (last-none)
;; END ADD
  )

  (:action action1
    :parameters (?b)
    :precondition (and (predicate2 ?b) (predicate1 ?b) (predicate3)
;; BEGIN ADD
    (or (and (odd ?b) (or (last-none) (last-even))) (and (even ?b) (last-odd)))
;; END ADD
                       )
    :effect (and (predicate4 ?b)
                 (not (predicate2 ?b))
                 (not (predicate3))
;; BEGIN ADD
                 (when (odd ?b) (and (last-odd) (not (last-even)) (not (last-none))))
                 (when (even ?b) (and (last-even) (not (last-odd))))
;; END ADD
    )
  )

  (:action action4
    :parameters (?b ?c)
    :precondition (and (predicate5 ?b ?c) (predicate1 ?b) (predicate3)
;; BEGIN ADD
    (or (and (odd ?b) (or (last-none) (last-even))) (and (even ?b) (last-odd)))
;; END ADD 
                       )
    :effect (and (predicate4 ?b)
                 (predicate1 ?c)
                 (not (predicate5 ?b ?c))
                 (not (predicate3))
;; BEGIN ADD
                 (when (odd ?b) (and (last-odd) (not (last-even)) (not (last-none))))
                 (when (even ?b) (and (last-even) (not (last-odd))))
;; END ADD          
                 )
  )

  (:action action2
    :parameters (?b)
;; BEGIN EDIT
    :precondition (and (predicate4 ?b) (or (even ?b) (odd ?b)))
;; END EDIT
    :effect (and (predicate2 ?b) (predicate1 ?b)
                 (predicate3) (not (predicate4 ?b)))
  )

  (:action action3
    :parameters (?b ?c)
    :precondition (and (predicate4 ?b) (predicate1 ?c)
;; BEGIN ADD
    (or (even ?b) (odd ?b))
;; END ADD
    )
    :effect (and (predicate5 ?b ?c) (predicate1 ?b)
                 (predicate3) (not (predicate4 ?b)))
  )
)
