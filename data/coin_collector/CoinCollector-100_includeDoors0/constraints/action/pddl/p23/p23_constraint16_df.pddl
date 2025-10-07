(define (domain coin-collector)
;; CONSTRAINT You can't pick up any coin if you haven't been to the corridor.
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
    (must-visit-room ?room - room)
    (visited-room)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction))
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (when (must-visit-room ?room2) (visited-room))
;; END ADD
    )
  )
  
  (:action take
    :parameters (?item - item ?room - room)
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item))
;; BEGIN ADD
    (visited-room)
;; END ADD
    )
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)