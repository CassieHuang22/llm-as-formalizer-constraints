(define (problem coin_collector_numLocations5_numDistractorItems0_seed48)
;; CONSTRAINT There is a decoy coin in the corridor.
  (:domain coin-collector)
  (:objects
    kitchen pantry backyard corridor bedroom - room
    north south east west - direction
;; BEGIN EDIT
    coin decoy_coin - item
;; END EDIT
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen backyard south)
    (connected pantry kitchen south)
    (connected backyard kitchen north)
    (connected backyard corridor east)
    (connected corridor backyard west)
    (connected corridor bedroom south)
    (connected bedroom corridor north)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (location decoy_coin corridor)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)