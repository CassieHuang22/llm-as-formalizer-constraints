(define (domain coin-collector)
;; CONSTRAINT You must visit the driveway at most 4 times.
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
    (visit-at-most-four-times ?room - room)
    (visited-room-once)
    (visited-room-twice)
    (visited-room-three-times)
    (visited-room-four-times)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction)
;; BEGIN ADD
    (or
        (and (visit-at-most-four-times ?room2) (not (visited-room-once)) (not (visited-room-twice)) (not (visted-room-three-times)) (not (visited-room-four-times)))
        (and (visit-at-most-four-times ?room2) (visited-room-once) (not (visited-room-twice)) (not (visited-room-three-times)) (not (visited-room-four-times)))
        (and (visit-at-most-four-times ?room2) (visited-room-once) (visited-room-twice) (not (visited-room-three-times)) (not (visited-room-four-times)))
        (and (visit-at-most-four-times ?room2) (visited-room-once) (visited-room-twice) (visited-room-three-times) (not (visited-room-four-times)))
        (not (visit-at-most-four-times ?room2))
    )
;; END ADD
    )
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (when (and (visit-at-most-four-times ?room2) (not (visited-room-once)) (not (visited-room-twice)) (not (visited-room-three-times)) (not (visited-room-four-times))) (visited-room-once))
    (when (and (visit-at-most-four-times ?room2) (visited-room-once) (not (visited-room-twice)) (not (visited-room-three-times)) (not (visited-room-four-times))) (visited-room-twice))
    (when (and (visit-at-most-four-times ?room2) (visited-room-once) (visited-room-twice) (not (visited-room-three-times)) (not (visited-room-four-times))) (visited-room-three-times))
    (when (and (visit-at-most-four-times ?room2) (visited-room-once) (visited-room-twice) (visited-room-three-times) (not (visited-room-four-times))) (visited-room-four-times))
;; END ADD
    )
  )
  
  (:action take
    :parameters (?item - item ?room - room)
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item)))
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)