(define (domain coin-collector)
;; Each room has their own ID number (kitchen=1, pantry=2, corridor=3, backyard=4, bedroom=5, living room = 6, bathroom=7, laundry room=8, driveway=9, street=10, supermarket=11) the sum of all IDs for the rooms you visit, including the starting room, cannot exceed 3.
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
    (kitchen ?room - room)
    (pantry ?room - room)
    (corridor ?room - room)
    (visited-kitchen) (visited-pantry) (visited-corridor)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction)
;; BEGIN ADD
    (or
      (and (kitchen ?room2) (not (visited-kitchen)) (not (visited-pantry)) (not (visited-corridor)))
      (and (pantry ?room2) (not (visited-kitchen)) (not (visited-pantry)) (not (visited-corridor)))
      (and (corridor ?room2) (not (visited-kitchen)) (not (visited-pantry)) (not (visited-corridor)))
      (and (pantry ?room2) (visited-kitchen) (not (visited-pantry)) (not (visited-corridor)))
    )
;; END ADD
    )
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (when (kitchen ?room2) (visited-kitchen))
    (when (pantry ?room2) (visited-pantry))
    (when (corridor ?room2) (visited-corridor))
;; END ADD
    )
  )
  
  (:action take
    :parameters (?item - item ?room - room)
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item))
;; BEGIN ADD
    (or
      (and (kitchen ?room) (visited-kitchen))
      (and (pantry ?room) (visited-pantry))
      (and (corridor ?room) (visited-corridor))
    )
;; END ADD
    )
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)