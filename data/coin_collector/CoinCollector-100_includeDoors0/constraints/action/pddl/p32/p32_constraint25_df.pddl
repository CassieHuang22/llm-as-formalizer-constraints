(define (domain coin-collector)
;; CONSTRAINT You can't go to the bedroom if you haven't been to the pantry. Also, you cannot pick up any coins if you haven't been to the backyard.
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
    (must-visit-before-coin ?room - room)
    (visited-room-before-next)
    (visited-room-before-coin)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction)
;; BEGIN ADD
    (not (and (next-room ?room2) (not (visited-room-before-next))))
;; END ADD
    )
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (when (must-visit-before-next ?room2) (visited-room-before-next))
    (when (must-visit-before-coin ?room2) (visited-room-before-coin))
;; END ADD
    )
  )
  
  (:action take
    :parameters (?item - item ?room - room)
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item))
;; BEGIN ADD
    (visited-room-before-coin)
;; END ADD
    )
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)