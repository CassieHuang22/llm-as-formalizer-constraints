(define (domain mystery_blocksworld)
;; CONSTRAINT Once you start performing actions on the objects, the sum of the object numbers in each cluster should not exceed 5.
  (:requirements :strips)
  (:predicates
      (predicate5 ?x ?y)
      (predicate2 ?x)
      (predicate1 ?x)
      (predicate4 ?x)
      (predicate3)
;; BEGIN ADD
      (val-1 ?x) (val-2 ?x) (val-3 ?x)
      (val-4 ?x) (val-5 ?x)

      (cap-0 ?x) (cap-1 ?x) (cap-2 ?x)
      (cap-3 ?x) (cap-4 ?x) (cap-5 ?x)
;; END ADD
      )

  (:action action1
     :parameters (?b)
     :precondition (and (predicate2 ?b) (predicate1 ?b) (predicate3))
     :effect (and (predicate4 ?b)
                  (not (predicate2 ?b))
                  (not (predicate3))
;; BEGIN ADD
                  (not (cap-0 ?b)) (not (cap-1 ?b)) (not (cap-2 ?b))
                  (not (cap-3 ?b)) (not (cap-4 ?b)) (not (cap-5 ?b))
;; END ADD
                  ))

  (:action action4
     :parameters (?top ?below)
     :precondition (and (predicate5 ?top ?below) (predicate1 ?top) (predicate3))
     :effect (and (predicate4 ?top)
                  (predicate1 ?below)
                  (not (predicate5 ?top ?below))
                  (not (predicate3))
;; BEGIN ADD
                  (not (cap-0 ?top)) (not (cap-1 ?top)) (not (cap-2 ?top))
                  (not (cap-3 ?top)) (not (cap-4 ?top)) (not (cap-5 ?top))
;; END ADD
                  ))

(:action action2
  :parameters (?b)
  :precondition (predicate4 ?b)
  :effect (and
    (predicate2 ?b)
    (predicate1 ?b)
    (predicate3)
    (not (predicate4 ?b))
;; BEGIN ADD
    (when (val-1 ?b) (cap-4 ?b))
    (when (val-2 ?b) (cap-3 ?b))
    (when (val-3 ?b) (cap-2 ?b))
    (when (val-4 ?b) (cap-1 ?b))
    (when (val-5 ?b) (cap-0 ?b))
;; END ADD
  )
)

  (:action action3
  :parameters (?top ?below)
  :precondition (and (predicate4 ?top) (predicate1 ?below)
;; BEGIN ADD
                     (or (val-1 ?top) (val-2 ?top) (val-3 ?top) (val-4 ?top) (val-5 ?top))
                     (or (cap-1 ?below) (cap-2 ?below) (cap-3 ?below) (cap-4 ?below) (cap-5 ?below))
;; END ADD
                     )
  :effect (and
    (not (predicate4 ?top))
    (not (predicate1 ?below))
    (predicate5 ?top ?below)
    (predicate1 ?top)
    (predicate3)
;; BEGIN ADD
    (when (and (val-1 ?top) (cap-1 ?below)) (cap-0 ?top))
    (when (and (val-1 ?top) (cap-2 ?below)) (cap-1 ?top))
    (when (and (val-1 ?top) (cap-3 ?below)) (cap-2 ?top))
    (when (and (val-1 ?top) (cap-4 ?below)) (cap-3 ?top))
    (when (and (val-1 ?top) (cap-5 ?below)) (cap-4 ?top))

    (when (and (val-2 ?top) (cap-2 ?below)) (cap-0 ?top))
    (when (and (val-2 ?top) (cap-3 ?below)) (cap-1 ?top))
    (when (and (val-2 ?top) (cap-4 ?below)) (cap-2 ?top))
    (when (and (val-2 ?top) (cap-5 ?below)) (cap-3 ?top))

    (when (and (val-3 ?top) (cap-3 ?below)) (cap-0 ?top))
    (when (and (val-3 ?top) (cap-4 ?below)) (cap-1 ?top))
    (when (and (val-3 ?top) (cap-5 ?below)) (cap-2 ?top))

    (when (and (val-4 ?top) (cap-4 ?below)) (cap-0 ?top))
    (when (and (val-4 ?top) (cap-5 ?below)) (cap-1 ?top))

    (when (and (val-5 ?top) (cap-5 ?below)) (cap-0 ?top))
;; END ADD
  )
)

)