(define (domain mystery_blocksworld)
;; CONSTRAINT If you perform a set of objects on object2, you must perform a set of actions on object4 immediately after. If you perform a set of actions on object4 you must perform a set of actions on object6 immediately after.
  (:requirements :strips)
  (:predicates
    (predicate5 ?x ?y)
    (predicate2 ?x)
    (predicate1 ?x)
    (predicate4 ?x)
    (predicate3)
;; BEGIN ADD
    (first-object-1 ?x)
    (second-object-1 ?x)
    (perform-second-1)
    (first-object-2 ?x)
    (second-object-2 ?x)
    (perform-second-2)
;; END ADD
  )

  (:action action1
    :parameters (?b)
    :precondition (and
      (predicate2 ?b)
      (predicate1 ?b)
      (predicate3)
;; BEGIN ADD
      (or (not (perform-second-1)) (second-object-1 ?b))
      (or (not (perform-second-2)) (second-object-2 ?b))
;; END ADD
    )
    :effect (and
      (not (predicate2 ?b))
      (not (predicate1 ?b))
      (not (predicate3))
      (predicate4 ?b)
;; BEGIN ADD
      (when (first-object-1 ?b) (perform-second-1))
      (when (first-object-2 ?b) (perform-second-2))
;; END ADD
    )
  )

  (:action action4
    :parameters (?b ?c)
    :precondition (and
      (predicate5 ?b ?c)
      (predicate1 ?b)
      (predicate3)
;; BEGIN ADD
      (or (not (perform-second-1)) (second-object-1 ?b))
      (or (not (perform-second-2)) (second-object-2 ?b))
;; END ADD
    )
    :effect (and
      (not (predicate5 ?b ?c))
      (predicate1 ?c)
      (not (predicate3))
      (predicate4 ?b)
;; BEGIN ADD
      (when (first-object-1 ?b) (perform-second-1))
      (when (first-object-2 ?b) (perform-second-2))
;; END ADD
    )
  )

  (:action action2
    :parameters (?b)
    :precondition (predicate4 ?b)
    :effect (and
      (predicate2 ?b)
      (predicate1 ?b)
      (predicate3)
      (not (predicate4 ?b))
;; BEGIN ADD
      (when (first-object-1 ?b) (perform-second-1))
      (when (second-object-1 ?b) (not (perform-second-1)))
      (when (first-object-2 ?b) (perform-second-2))
      (when (second-object-2 ?b) (not (perform-second-2)))
;; END ADD
    )
  )

  (:action action3
    :parameters (?b ?c)
    :precondition (and
      (predicate4 ?b)
      (predicate1 ?c)
    )
    :effect (and
      (predicate5 ?b ?c)
      (not (predicate1 ?c))
      (predicate1 ?b)
      (predicate3)
      (not (predicate4 ?b))
;; BEGIN ADD
      (when (first-object-1 ?b) (perform-second-1))
      (when (second-object-1 ?b) (not (perform-second-1)))
      (when (first-object-2 ?b) (perform-second-2))
      (when (second-object-2 ?b) (not (perform-second-2)))
;; END ADD
    )
  )
)
