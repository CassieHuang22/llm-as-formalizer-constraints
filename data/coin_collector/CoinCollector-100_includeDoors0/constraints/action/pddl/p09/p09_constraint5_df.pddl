(define (domain coin-collector)
;; CONSTRAINT You must take exactly 4 move actions before taking any coin.
  (:requirements :strips :typing)
  (:types
    room
    direction
    item
;; BEGIN ADD
    step
;; END ADD
  )
  (:predicates
    (at ?room - room)
    (connected ?room1 - room ?room2 - room ?direction - direction)
    (closed-door ?room1 - room ?room2 - room ?direction - direction)
    (location ?item - item ?room - room)
    (taken ?item - item)
    (is-reverse ?direction - direction ?reverse - direction)
;; BEGIN ADD
    (current ?step - step)
    (next ?step1 - step ?step2 - step)
    (final-step ?s - step)
;; END ADD
  )

  (:action move
;; BEGIN EDIT
    :parameters (?room1 - room ?room2 - room ?direction - direction ?step1 - step ?step2 - step)
;; END EDIT
    :precondition (and (at ?room1) (connected ?room1 ?room2 ?direction)
;; BEGIN ADD
    (current ?step1) (next ?step1 ?step2)
;; END ADD
    )
    :effect (and (not (at ?room1)) (at ?room2)
;; BEGIN ADD
    (not (current ?step1)) (current ?step2)
;; END ADD
    )
  )
  
  (:action take
;; BEGIN EDIT
    :parameters (?item - item ?room - room ?step - step)
;; END EDIT
    :precondition (and (at ?room) (location ?item ?room) (not (taken ?item))
;; BEGIN ADD
    (current ?step) (final-step ?step)
;; END ADD
    )
    :effect (and (taken ?item) (not (location ?item ?room)))
  )
)