(define (problem coin_collector_numLocations3_numDistractorItems0_seed75)
;; CONSTRAINT You cannot be more than two rooms away from the kitchen.
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
    (location coin kitchen)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (within-distance-room pantry)
    (within-distance-room corridor)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)