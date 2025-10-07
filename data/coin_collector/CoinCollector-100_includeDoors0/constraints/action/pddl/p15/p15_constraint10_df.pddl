(define (domain coin-collector)
;; CONSTRAINT You must visit the corridor at most three times.
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
    (visit-at-most-three-times ?room - room)
    (visited-room-once)
    (visited-room-twice)
    (visited-room-three-times)
;; END ADD
  )

  (:action move
    :parameters (?room1 - room ?room2 - room ?direction - direction)
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction)
;; BEGIN ADD
    (or
        (and (visit-at-most-three-times ?room2) (not (visited-room-once)) (not (visited-room-twice)) (not (visted-room-three-times)))
        (and (visit-at-most-three-times ?room2) (visited-room-once) (not (visited-room-twice)) (not (visited-room-three-times)))
        (and (visit-at-most-three-times ?room2) (visited-room-once) (visited-room-twice) (not (visited-room-three-times)))
        (not (visit-at-most-three-times ?room2))
    )
;; END ADD
    )
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (when (and (visit-at-most-three-times ?room2) (not (visited-room-once)) (not (visited-room-twice)) (not (visited-room-three-times))) (visited-room-once))
    (when (and (visit-at-most-three-times ?room2) (visited-room-once) (not (visited-room-twice)) (not (visited-room-three-times))) (visited-room-twice))
    (when (and (visit-at-most-three-times ?room2) (visited-room-once) (visited-room-twice) (not (visited-room-three-times))) (visited-room-three-times))
;; END ADD
    )
  )
  
  (:action take
    :parameters (?item - item ?room - room)
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item)))
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)