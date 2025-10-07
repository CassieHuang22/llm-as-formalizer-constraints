(define (domain coin-collector)
;; CONSTRAINT If you visit the corridor, you must visit the bedroom within the next two moves.
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
    (one-move-left)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction)
;; BEGIN ADD
    (or (not (one-move-left)) (second-room ?room2))
;; END ADD
    )
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (when (first-room ?room2) (must-visit-second-room))
    (when (and (must-visit-second-room) (not (first-room ?room2)) (not (second-room ?room2))) (one-move-left))
    (when (and (second-room ?room2) (not (must-visit-second-room))) (not (one-move-left)))
    (when (and (one-move-left) (not (second-room ?room2))) (not (one-move-left)))
;; END ADD
    )
  )
  
  (:action take
    :parameters (?item - item ?room - room)
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item)))
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)