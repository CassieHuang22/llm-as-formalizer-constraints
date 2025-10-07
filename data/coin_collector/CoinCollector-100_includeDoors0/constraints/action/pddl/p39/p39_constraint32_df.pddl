(define (domain coin-collector)
;; CONSTRAINT You cannot go to the pantry from the kitchen if you haven't visited the backyard.
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
    (in-between-room ?room - room)
    (visited-room)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction)
;; BEGIN ADD
    (or (not (and (first-room ?room1) (second-room ?room2))) (visited-room))
;; END ADD
    )
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (when (in-between-room ?room2) (visited-room))
;; END ADD
    )
  )
  
  (:action take
    :parameters (?item - item ?room - room)
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item)))
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)