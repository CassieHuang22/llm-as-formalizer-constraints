(define (problem coin_collector_numLocations3_numDistractorItems0_seed43)
;; CONSTRAINT There is a decoy coin in the kitchen.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor - room
    north south east west - direction
;; BEGIN EDIT
    coin decoy_coin - item
;; END EDIT
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen corridor west)
    (connected pantry kitchen south)
    (connected corridor kitchen east)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (location decoy_coin kitchen)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)