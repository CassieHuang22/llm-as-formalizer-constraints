(define (problem coin_collector_numLocations5_numDistractorItems0_seed7)
  (:domain coin-collector)
  (:objects
    kitchen pantry backyard corridor bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen backyard west)
    (connected pantry kitchen north)
    (connected backyard kitchen east)
    (connected backyard corridor west)
    (connected corridor backyard east)
    (connected corridor bedroom west)
    (connected bedroom corridor east)
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