(define (domain mystery_blocksworld)
;; CONSTRAINT If you perform a set of actions on object1, you must perform a set of actions on object2 within the next 6 sets of actions.
  (:requirements :strips)
  (:predicates
    (predicate5 ?x ?y)
    (predicate2 ?x)
    (predicate1 ?x)
    (predicate3)
    (predicate4 ?x)
;; BEGIN ADD
    (first-object ?x)
    (second-object ?x)
    (perform-second-6)
    (perform-second-5)
    (perform-second-4)
    (perform-second-3)
    (perform-second-2)
    (perform-second-1)
    (perform-second-0)
;; END ADD
  )

  (:action action1
    :parameters (?b)
    :precondition (and (predicate1 ?b) (predicate2 ?b) (predicate3)
;; BEGIN ADD
    (not (perform-second-0))
;; END ADD
    )
    :effect (and (not (predicate2 ?b))
            (not (predicate1 ?b))
            (not (predicate3))
            (predicate4 ?b)))

  (:action action4
    :parameters (?top ?bottom)
    :precondition (and (predicate5 ?top ?bottom) (predicate1 ?top) (predicate3)
;; BEGIN ADD
    (not (perform-second-0))
;; END ADD
    )
    :effect (and (not (predicate5 ?top ?bottom))
            (predicate1 ?bottom)
            (not (predicate1 ?top))
            (not (predicate3))
            (predicate4 ?top)))

  (:action action2
  :parameters (?b)
;; BEGIN EDIT
  :precondition (and (predicate4 ?b) (not (perform-second-0)))
;; END EDIT
  :effect (and
    (predicate2 ?b)
    (predicate1 ?b)
    (predicate3)
    (not (predicate4 ?b))
;; BEGIN ADD
    (when (first-object ?b)
      (and (perform-second-6)
           (not (perform-second-5))
           (not (perform-second-4))
           (not (perform-second-3))
           (not (perform-second-2))
           (not (perform-second-1))))

    (when (second-object ?b)
      (and (not (perform-second-6))
           (not (perform-second-5))
           (not (perform-second-4))
           (not (perform-second-3))
           (not (perform-second-2))
           (not (perform-second-1))))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-6))
      (and (not (perform-second-6)) (perform-second-5)))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-5))
      (and (not (perform-second-5)) (perform-second-4)))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-4))
      (and (not (perform-second-4)) (perform-second-3)))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-3))
      (and (not (perform-second-3)) (perform-second-2)))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-2))
      (and (not (perform-second-2)) (perform-second-1)))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-1))
      (and (not (perform-second-1)) (perform-second-0)))
;; END ADD
  )
)

(:action action3
  :parameters (?b ?below)
  :precondition (and (predicate4 ?b) (predicate1 ?below)
;; BEGIN ADD
  (not (perform-second-0))
;; END ADD  
  )
  :effect (and
    (not (predicate4 ?b))
    (not (predicate1 ?below))
    (predicate5 ?b ?below)
    (predicate1 ?b)
    (predicate3)
;; BEGIN ADD
    (when (first-object ?b)
      (and (perform-second-6)
           (not (perform-second-5))
           (not (perform-second-4))
           (not (perform-second-3))
           (not (perform-second-2))
           (not (perform-second-1))))

    (when (second-object ?b)
      (and (not (perform-second-6))
           (not (perform-second-5))
           (not (perform-second-4))
           (not (perform-second-3))
           (not (perform-second-2))
           (not (perform-second-1))))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-6))
      (and (not (perform-second-6)) (perform-second-5)))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-5))
      (and (not (perform-second-5)) (perform-second-4)))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-4))
      (and (not (perform-second-4)) (perform-second-3)))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-3))
      (and (not (perform-second-3)) (perform-second-2)))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-2))
      (and (not (perform-second-2)) (perform-second-1)))

    (when (and (not (first-object ?b)) (not (second-object ?b)) (perform-second-1))
      (and (not (perform-second-1)) (perform-second-0)))
;; END ADD
  )
)
  
  
)
