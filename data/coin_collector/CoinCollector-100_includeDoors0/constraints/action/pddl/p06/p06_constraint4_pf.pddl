(define (problem coin_collector_numLocations5_numDistractorItems0_seed11)
;; CONSTRAINT You must visit the backyard twice.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor bedroom backyard - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen corridor west)
    (connected pantry kitchen north)
    (connected corridor kitchen east)
    (connected corridor bedroom south)
    (connected corridor backyard west)
    (connected bedroom corridor north)
    (connected backyard corridor east)
    (location coin kitchen)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (must-visit backyard)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)