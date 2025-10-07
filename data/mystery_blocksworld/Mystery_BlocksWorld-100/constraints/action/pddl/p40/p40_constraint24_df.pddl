(define (domain mystery_blocksworld)
;; CONSTRAINT If you perform a set of actions on an object with a number that is a multiple of 3, you must perform a set of actions with an object with a number that is a multiple of 5 immediately after.
  (:requirements :strips)
  (:predicates
    (predicate5 ?x ?y)
    (predicate2 ?x)
    (predicate1 ?x)
    (predicate4 ?x)
    (predicate3)
;; BEGIN ADD
    (first-object ?x)
    (second-object ?x)
    (perform-action-on-second-object)
;; END ADD
  )

  (:action action1
    :parameters (?b)
    :precondition (and
      (predicate2 ?b)
      (predicate1 ?b)
      (predicate3)
;; BEGIN ADD
      (or (not (perform-action-on-second-object)) (second-object ?b))
;; END ADD
    )
    :effect (and
      (not (predicate2 ?b))
      (not (predicate1 ?b))
      (not (predicate3))
      (predicate4 ?b)
;; BEGIN ADD
      (when (first-object ?b) (perform-action-on-second-object))
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
      (or (not (perform-action-on-second-object)) (second-object ?b))
;; END ADD
    )
    :effect (and
      (not (predicate5 ?b ?c))
      (predicate1 ?c)
      (not (predicate3))
      (predicate4 ?b)
;; BEGIN ADD
      (when (first-object ?b) (perform-action-on-second-object))
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
      (when (first-object ?b) (perform-action-on-second-object))
      (when (second-object ?b) (not (perform-action-on-second-object)))
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
      (when (first-object ?b) (perform-action-on-second-object))
      (when (second-object ?b) (not (perform-action-on-second-object)))
;; END ADD
    )
  )
)
