(define (problem coin_collector_numLocations3_numDistractorItems0_seed97)
;; CONSTRAINT The coin is in the kitchen.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry east)
    (connected kitchen corridor west)
    (connected pantry kitchen west)
    (connected corridor kitchen east)
;; BEGIN EDIT
    (location coin kitchen)
;; END EDIT
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)