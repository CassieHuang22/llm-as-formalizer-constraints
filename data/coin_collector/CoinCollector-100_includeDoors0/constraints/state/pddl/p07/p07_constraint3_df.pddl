(define (domain coin-collector)
;; CONSTRAINT Each room has their own ID number (kitchen=1, pantry=2, corridor=3, backyard=4, bedroom=5, living room = 6, bathroom=7, laundry room=8, driveway=9, street=10, supermarket=11) the sum of all IDs for the rooms you visit, including the starting room, cannot exceed 10.
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
    (kitchen ?r - room)
    (pantry ?r - room)
    (corridor ?r - room)
    (backyard ?r - room)
    (bedroom ?r - room)
    (visited-kitchen)
    (visited-pantry)
    (visited-corridor)
    (visited-backyard)
    (visited-bedroom)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction)
;; BEGIN ADD
    (and (kitchen ?room2) (not (visited-kitchen)) (not (visited-pantry)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (pantry ?room2) (not (visited-kitchen)) (not (visited-pantry)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (corridor ?room2) (not (visited-kitchen)) (not (visited-pantry)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (backyard ?room2) (not (visited-kitchen)) (not (visited-pantry)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (bedroom ?room2) (not (visited-kitchen)) (not (visited-pantry)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))

    (and (visited-kitchen) (pantry ?room2) (not (visited-pantry)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-kitchen) (corridor ?room2) (not (visited-pantry)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-kitchen) (backyard ?room2) (not (visited-pantry)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-kitchen) (bedroom ?room2) (not (visited-pantry)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))

    (and (visited-pantry) (kitchen ?room2) (not (visited-kitchen)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-pantry) (corridor ?room2) (not (visited-kitchen)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-pantry) (backyard ?room2) (not (visited-kitchen)) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))

    (and (visited-corridor) (kitchen ?room2) (not (visited-kitchen)) (not (visited-pantry)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-corridor) (pantry ?room2) (not (visited-kitchen)) (not (visited-pantry)) (not (visited-backyard)) (not (visited-bedroom)))

    (and (visited-kitchen) (visited-pantry) (corridor ?room2) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-kitchen) (visited-pantry) (backyard ?room2) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-kitchen) (visited-pantry) (bedroom ?room2) (not (visited-corridor)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-kitchen) (visited-corridor) (backyard ?room2) (not (visited-pantry)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-kitchen) (visited-corridor) (bedroom ?room2) (not (visited-pantry)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-kitchen) (visited-backyard) (bedroom ?room2) (not (visited-pantry)) (not (visited-bedroom)) (not (visited-corridor)))
    (and (visited-pantry) (visited-corridor) (backyard ?room2) (not (visited-kithcen)) (not (visited-backyard)) (not (visited-bedroom)))
    (and (visited-pantry) (visited-corridor) (bedroom ?room2) (not (visited-kitchen)) (not (visited-backyard)) (not (visited-bedroom)))
;; END ADD
    )
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (when (kitchen ?room2) (visited-kitchen))
    (when (pantry ?room2) (visited-pantry))
    (when (corridor ?room2) (visited-corridor))
    (when (backyard ?room2) (visited-backyard))
    (when (bedroom ?room2) (visited-bedroom))
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
      (and (backyard ?room) (visited-backyard))
      (and (bedroom ?room) (visited-bedroom))
    )
;; END ADD
    )
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)