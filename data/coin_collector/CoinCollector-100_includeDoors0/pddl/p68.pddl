(define (problem coin_collector_numLocations5_numDistractorItems0_seed25)
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor backyard bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen corridor east)
    (connected kitchen backyard west)
    (connected pantry kitchen south)
    (connected corridor kitchen west)
    (connected corridor bedroom east)
    (connected backyard kitchen east)
    (connected bedroom corridor west)
    (location coin bedroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)