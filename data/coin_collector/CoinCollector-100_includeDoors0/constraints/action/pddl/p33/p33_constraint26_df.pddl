(define (domain coin-collector)
;; CONSTRAINT You must visit the laundry room before the living room.
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
    (must-visit-before-next ?room - room)
    (next-room ?room - room)
    (visited-room)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction)
;; BEGIN ADD
    (not (and (next-room ?room2) (not (visited-room))))
;; END ADD
    )
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (when (must-visit-before-next ?room2) (visited-room))
;; END ADD
    )
  )
  
  (:action take
    :parameters (?item - item ?room - room)
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item)))
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)