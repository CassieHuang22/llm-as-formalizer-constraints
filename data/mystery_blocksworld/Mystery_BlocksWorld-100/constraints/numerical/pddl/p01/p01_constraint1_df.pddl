(define (domain mystery_blocksworld)
;; CONSTRAINT The higher number the object, the heavier it is. Once, you start performing actions on the objects, do not action3 heavier objects with lighter objects
  (:requirements :strips )
  (:predicates
    (predicate5 ?x ?y)
    (predicate2 ?x)
    (predicate1 ?x)
    (predicate3)
    (predicate4 ?x)
;; BEGIN ADD
    (heavier ?b ?c)
;; END ADD
  )

  (:action action1
    :parameters (?b)
    :precondition (and (predicate1 ?b) (predicate2 ?b) (predicate3))
    :effect (and (not (predicate2 ?b))
                 (not (predicate1 ?b))
                 (not (predicate3))
                 (predicate4 ?b))
  )

  (:action action4
    :parameters (?b ?c)
    :precondition (and (predicate5 ?b ?c) (predicate1 ?b) (predicate3))
    :effect (and (not (predicate5 ?b ?c))
                 (predicate1 ?c)
                 (not (predicate1 ?b))
                 (not (predicate3))
                 (predicate4 ?b))
  )

  (:action action2
    :parameters (?b)
    :precondition (predicate4 ?b)
    :effect (and (predicate2 ?b)
                 (predicate1 ?b)
                 (predicate3)
                 (not (predicate4 ?b)))
  )

  (:action action3
    :parameters (?b ?c)
    :precondition (and (predicate4 ?b) (predicate1 ?c)
;; BEGIN ADD
                       (not (heavier ?b ?c)))
;; END ADD
    :effect (and (not (predicate4 ?b))
                 (not (predicate1 ?c))
                 (predicate5 ?b ?c)
                 (predicate1 ?b)
                 (predicate3))
  )
)
