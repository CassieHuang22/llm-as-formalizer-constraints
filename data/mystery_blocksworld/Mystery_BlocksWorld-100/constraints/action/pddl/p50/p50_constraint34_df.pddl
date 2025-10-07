(define (domain mystery_blocksworld)
;; CONSTRAINT Do not perform action3 with object1 and object2.
  (:requirements :strips)
(:predicates (predicate1 ?x)
             (predicate2 ?x)
             (predicate3)
             (predicate4 ?x)
             (predicate5 ?x ?y)
;; BEGIN ADD
              (not-allowed ?x ?y)
;; END ADD
             )

(:action action1
  :parameters (?object1)
  :precondition (and (predicate1 ?object1) (predicate2 ?object1) (predicate3))
  :effect (and (predicate4 ?object1) (not (predicate1 ?object1)) (not (predicate2 ?object1)) 
               (not (predicate3))))

(:action action2
  :parameters  (?object1)
  :precondition (predicate4 ?object1)
  :effect (and (predicate1 ?object1) (predicate3) (predicate2 ?object1) 
               (not (predicate4 ?object1))))

(:action action3
  :parameters  (?object1 ?object2)
  :precondition (and (predicate1 ?object2) (predicate4 ?object1) 
;; BEGIN ADD
                      (not (not-allowed ?object1 ?object2))
;; END ADD
                )
  :effect (and (predicate3) (predicate1 ?object1) (predicate5 ?object1 ?object2)
               (not (predicate1 ?object2)) (not (predicate4 ?object1))))

(:action action4
  :parameters  (?object1 ?object2)
  :precondition (and (predicate5 ?object1 ?object2) (predicate1 ?object1) (predicate3))
  :effect (and (predicate4 ?object1) (predicate1 ?object2)
               (not (predicate5 ?object1 ?object2)) (not (predicate1 ?object1)) (not (predicate3)))))