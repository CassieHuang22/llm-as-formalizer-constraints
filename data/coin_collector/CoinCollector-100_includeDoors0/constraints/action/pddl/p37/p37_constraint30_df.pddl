(define (domain coin-collector)
;; CONSTRAINT If you visit the corridor, you must visit the pantry directly after.
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
    (visit-first-room)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction)
;; BEGIN ADD
    (or (not (visit-first-room)) (second-room ?room2))
;; END ADD
    )
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (when (first-room ?room2) (visit-first-room))
    (when (second-room ?room2) (not (visit-first-room)))
;; END ADD
    )
  )
  
  (:action take
    :parameters (?item - item ?room - room)
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item)))
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)