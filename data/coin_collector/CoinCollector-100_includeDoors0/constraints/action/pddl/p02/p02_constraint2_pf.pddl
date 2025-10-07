(define (problem coin_collector_numLocations3_numDistractorItems0_seed49)
;; CONSTRAINT You must visit the corridor twice.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen corridor west)
    (connected pantry kitchen south)
    (connected corridor kitchen east)
    (location coin kitchen)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (must-visit corridor)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)