(define (domain blocksworld)
;; CONSTRAINT Once you start moving blocks, the sum of the block numbers in each stack should not exceed 5.
  (:requirements :strips)
  (:predicates
      (on ?x ?y)
      (on-table ?x)
      (clear ?x)
      (holding ?x)
      (arm-empty)
;; BEGIN ADD
      (val-1 ?x) (val-2 ?x) (val-3 ?x)
      (val-4 ?x) (val-5 ?x)

      (cap-0 ?x) (cap-1 ?x) (cap-2 ?x)
      (cap-3 ?x) (cap-4 ?x) (cap-5 ?x)
;; END ADD
      )

  (:action pickup
     :parameters (?b)
     :precondition (and (on-table ?b) (clear ?b) (arm-empty))
     :effect (and (holding ?b)
                  (not (on-table ?b))
                  (not (arm-empty))
;; BEGIN ADD
                  (not (cap-0 ?b)) (not (cap-1 ?b)) (not (cap-2 ?b))
                  (not (cap-3 ?b)) (not (cap-4 ?b)) (not (cap-5 ?b))
;; END ADD
                  ))

  (:action unstack
     :parameters (?top ?below)
     :precondition (and (on ?top ?below) (clear ?top) (arm-empty))
     :effect (and (holding ?top)
                  (clear ?below)
                  (not (on ?top ?below))
                  (not (arm-empty))
;; BEGIN ADD
                  (not (cap-0 ?top)) (not (cap-1 ?top)) (not (cap-2 ?top))
                  (not (cap-3 ?top)) (not (cap-4 ?top)) (not (cap-5 ?top))
;; END ADD
                  ))

(:action putdown
  :parameters (?b)
  :precondition (holding ?b)
  :effect (and
    (on-table ?b)
    (clear ?b)
    (arm-empty)
    (not (holding ?b))
;; BEGIN ADD
    (when (val-1 ?b) (cap-4 ?b))
    (when (val-2 ?b) (cap-3 ?b))
    (when (val-3 ?b) (cap-2 ?b))
    (when (val-4 ?b) (cap-1 ?b))
    (when (val-5 ?b) (cap-0 ?b))
;; END ADD
  )
)

  (:action stack
  :parameters (?top ?below)
  :precondition (and (holding ?top) (clear ?below)
;; BEGIN ADD
                     (or (val-1 ?top) (val-2 ?top) (val-3 ?top) (val-4 ?top) (val-5 ?top))
                     (or (cap-1 ?below) (cap-2 ?below) (cap-3 ?below) (cap-4 ?below) (cap-5 ?below))
;; END ADD
                     )
  :effect (and
    (not (holding ?top))
    (not (clear ?below))
    (on ?top ?below)
    (clear ?top)
    (arm-empty)
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