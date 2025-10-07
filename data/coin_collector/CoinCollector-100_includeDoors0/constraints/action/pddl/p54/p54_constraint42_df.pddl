(define (domain coin-collector)
;; CONSTRAINT You can only move west or move east.
  (:requirements :strips :typing)
  (:types
    room
    direction
    item
  )
  ;; BEGIN ADD
    (allowed-direction ?direction - direction)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction)
;; BEGIN ADD
    (allowed-direction ?direction)
;; END ADD
    )
    :effect (and (not (at ?room1)) (at ?room2))
  )
  
  (:action take
    :parameters (?item - item ?room - room)
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item)))
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)