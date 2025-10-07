(define (problem coin_collector_numLocations3_numDistractorItems0_seed60)
;; CONSTRAINT You can only move south or move west.
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor south)
    (connected kitchen pantry west)
    (connected corridor kitchen north)
    (connected pantry kitchen east)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (allowed-direction south)
    (allowed-direction west)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)