(define (domain blocksworld)
;; CONSTRAINT If you move block1, you must move block2 or block3 immediately after.
  (:requirements :strips)
  (:predicates
    (on ?x ?y)
    (on-table ?x)
    (clear ?x)
    (holding ?x)
    (arm-empty)
;; BEGIN ADD
    (first-block ?x)
    (second-block ?x)
    (must-move-second-block)
;; END ADD
  )

  (:action pickup
    :parameters (?b)
    :precondition (and
      (on-table ?b)
      (clear ?b)
      (arm-empty)
;; BEGIN ADD
      (or (not (must-move-second-block)) (second-block ?b))
;; END ADD
    )
    :effect (and
      (not (on-table ?b))
      (not (clear ?b))
      (not (arm-empty))
      (holding ?b)
;; BEGIN ADD
      (when (first-block ?b) (must-move-second-block))
;; END ADD
    )
  )

  (:action unstack
    :parameters (?b ?c)
    :precondition (and
      (on ?b ?c)
      (clear ?b)
      (arm-empty)
;; BEGIN ADD
      (or (not (must-move-second-block)) (second-block ?b))
;; END ADD
    )
    :effect (and
      (not (on ?b ?c))
      (clear ?c)
      (not (arm-empty))
      (holding ?b)
;; BEGIN ADD
      (when (first-block ?b) (must-move-second-block))
;; END ADD
    )
  )

  (:action putdown
    :parameters (?b)
    :precondition (holding ?b)
    :effect (and
      (on-table ?b)
      (clear ?b)
      (arm-empty)
      (not (holding ?b))
;; BEGIN ADD
      (when (first-block ?b) (must-move-second-block))
      (when (second-block ?b) (not (must-move-second-block)))
;; END ADD
    )
  )

  (:action stack
    :parameters (?b ?c)
    :precondition (and
      (holding ?b)
      (clear ?c)
    )
    :effect (and
      (on ?b ?c)
      (not (clear ?c))
      (clear ?b)
      (arm-empty)
      (not (holding ?b))
;; BEGIN ADD
      (when (first-block ?b) (must-move-second-block))
      (when (second-block ?b) (not (must-move-second-block)))
;; END ADD
    )
  )
)
