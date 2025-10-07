(define (domain coin-collector)
;; CONSTRAINT If you visit the corridor, you must visit the bedroom within the next four moves.
  (:requirements :strips :typing)
  (:types
    room
    direction
    item
  )
  (:predicates
    (at ?room - room)
    (connected ?room1 - room ?room2 - room ?direction - direction)
    (closed-door ?room1 - room ?room2 - room ?direction - direction)
    (location ?item - item ?room - room)
    (taken ?item - item)
    (is-reverse ?direction - direction ?reverse - direction)
;; BEGIN ADD
    (first-room ?room - room)
    (second-room ?room - room)
    (must-visit-second-room)
    (deadline-1) (deadline-2) (deadline-3) (deadline-4)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction))
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (when (first-room ?room2) (and (must-visit-second-room) (deadline-4)))
    (when (and (must-visit-second-room) (deadline-4) (not (second-room ?room2))) (and (not (deadline-4)) (deadline-3)))
    (when (and (must-visit-second-room) (deadline-3) (not (second-room ?room2))) (and (not (deadline-3)) (deadline-2)))
    (when (and (must-visit-second-room) (deadline-2) (not (second-room ?room2))) (and (not (deadline-2)) (deadline-1)))
    (when (and (must-visit-second-room) (deadline-1) (not (second-room ?room2))) (not (deadline-1)))

    (when (second-room ?room2) (and (not (must-visit-second-room)) (not (deadline-1)) (not (deadline-2)) (not (deadline-3)) (not (deadline-4))))
;; END ADD
    )
  )
  
  (:action take
    :parameters (?item - item ?room - room)
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item)))
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)