(define (problem coin_collector_numLocations5_numDistractorItems0_seed42)
  (:domain coin-collector)
  (:objects
    kitchen pantry backyard corridor bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen backyard east)
    (connected pantry kitchen north)
    (connected backyard kitchen west)
    (connected backyard corridor north)
    (connected corridor backyard south)
    (connected corridor bedroom east)
    (connected bedroom corridor west)
    (location coin backyard)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)