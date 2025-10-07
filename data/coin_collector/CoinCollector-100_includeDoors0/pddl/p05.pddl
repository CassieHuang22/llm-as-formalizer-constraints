(define (problem coin_collector_numLocations5_numDistractorItems0_seed68)
  (:domain coin-collector)
  (:objects
    kitchen backyard pantry corridor bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard east)
    (connected kitchen pantry west)
    (connected backyard kitchen west)
    (connected backyard corridor north)
    (connected pantry kitchen east)
    (connected corridor backyard south)
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