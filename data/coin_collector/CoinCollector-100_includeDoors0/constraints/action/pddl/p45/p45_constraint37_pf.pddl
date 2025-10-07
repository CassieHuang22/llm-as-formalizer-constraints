(define (problem coin_collector_numLocations5_numDistractorItems0_seed69)
;; CONSTRAINT Do not move into the backyard.
  (:domain coin-collector)
  (:objects
    kitchen backyard pantry corridor bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard north)
    (connected kitchen pantry south)
    (connected kitchen corridor east)
    (connected backyard kitchen south)
    (connected pantry kitchen north)
    (connected corridor kitchen west)
    (connected corridor bedroom north)
    (connected bedroom corridor south)
    (location coin bedroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (not-allowed-room backyard)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)