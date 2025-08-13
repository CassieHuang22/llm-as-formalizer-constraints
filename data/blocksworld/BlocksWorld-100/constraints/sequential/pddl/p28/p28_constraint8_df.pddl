(define (domain blocksworld)
;; CONSTRAINT If you move block1, you must move block2 within the next 4 moves.
  (:requirements :strips)
  (:predicates
    (on ?x ?y)
    (on-table ?x)
    (clear ?x)
    (arm-empty)
    (holding ?x)
;; BEGIN ADD
    (first-block ?x)
    (second-block ?x)
    (move-second-4)
    (move-second-3)
    (move-second-2)
    (move-second-1)
    (move-second-0)
;; END ADD
  )

  (:action pickup
    :parameters (?b)
    :precondition (and (clear ?b) (on-table ?b) (arm-empty)
;; BEGIN ADD
    (not (move-second-0))
;; END ADD
    )
    :effect (and (not (on-table ?b))
            (not (clear ?b))
            (not (arm-empty))
            (holding ?b)))

  (:action unstack
    :parameters (?top ?bottom)
    :precondition (and (on ?top ?bottom) (clear ?top) (arm-empty)
;; BEGIN ADD
    (not (move-second-0))
;; END ADD
    )
    :effect (and (not (on ?top ?bottom))
            (clear ?bottom)
            (not (clear ?top))
            (not (arm-empty))
            (holding ?top)))


  (:action putdown
    :parameters (?b)
;; BEGIN EDIT
    :precondition (and (holding ?b) (not (move-second-0)))
;; END EDIT
    :effect (and
    (on-table ?b)
    (clear ?b)
    (arm-empty)
    (not (holding ?b))
;; BEGIN ADD
    (when (first-block ?b)
      (and
        (move-second-4)
        (not (move-second-3))
        (not (move-second-2))
        (not (move-second-1))))

    (when (second-block ?b)
      (and
        (not (move-second-4))
        (not (move-second-3))
        (not (move-second-2))
        (not (move-second-1))))

    (when (and
      (not (first-block ?b))
      (not (second-block ?b))
      (move-second-4))
      (and (not (move-second-4))
           (move-second-3)))

    (when (and
      (not (first-block ?b))
      (not (second-block ?b))
      (move-second-3))
      (and (not (move-second-3))
           (move-second-2)))

    (when (and
      (not (first-block ?b))
      (not (second-block ?b))
      (move-second-2))
      (and (not (move-second-2))
           (move-second-1)))

    (when (and
      (not (first-block ?b))
      (not (second-block ?b))
      (move-second-1))
      (and (not (move-second-1))
            (move-second-0)))
;; END ADD
  )
)

(:action stack
  :parameters (?b ?below)
  :precondition (and (holding ?b) (clear ?below)
;; BEGIN ADD
  (not (move-second-0))
;; END ADD
  )
  :effect (and
    (not (holding ?b))
    (not (clear ?below))
    (on ?b ?below)
    (clear ?b)
    (arm-empty)
;; BEGIN ADD
    (when (first-block ?b)
      (and
        (move-second-4)
        (not (move-second-3))
        (not (move-second-2))
        (not (move-second-1))))

    (when (second-block ?b)
      (and
        (not (move-second-4))
        (not (move-second-3))
        (not (move-second-2))
        (not (move-second-1))))

    (when (and
      (not (first-block ?b))
      (not (second-block ?b))
      (move-second-4))
      (and (not (move-second-4))
           (move-second-3)))

    (when (and
      (not (first-block ?b))
      (not (second-block ?b))
      (move-second-3))
      (and (not (move-second-3))
           (move-second-2)))

    (when (and
      (not (first-block ?b))
      (not (second-block ?b))
      (move-second-2))
      (and (not (move-second-2))
           (move-second-1)))

    (when (and
      (not (first-block ?b))
      (not (second-block ?b))
      (move-second-1))
      (and (not (move-second-1))
            (move-second-0)))
;; END ADD
  )
)
  
  
)
