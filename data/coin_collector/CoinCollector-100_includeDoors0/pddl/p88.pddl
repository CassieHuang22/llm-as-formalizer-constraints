(define (problem coin_collector_numLocations5_numDistractorItems0_seed43)
  (:domain coin-collector)
  (:objects
    kitchen backyard pantry corridor bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard north)
    (connected kitchen pantry west)
    (connected backyard kitchen south)
    (connected backyard corridor west)
    (connected pantry kitchen east)
    (connected corridor backyard east)
    (connected corridor bedroom west)
    (connected bedroom corridor east)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)