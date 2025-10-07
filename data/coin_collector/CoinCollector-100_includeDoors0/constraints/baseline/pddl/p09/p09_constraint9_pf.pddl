(define (problem coin_collector_numLocations7_numDistractorItems0_seed70)
  (:domain coin-collector)
  (:objects
    kitchen living_room pantry bathroom backyard corridor bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen living_room north)
    (connected kitchen pantry south)
    (connected kitchen bathroom west)
    (connected living_room kitchen south)
    (connected living_room backyard north)
    (connected pantry kitchen north)
    (connected bathroom kitchen east)
    (connected backyard living_room south)
    (connected backyard corridor west)
    (connected corridor backyard east)
    (connected corridor bedroom north)
    (connected bedroom corridor south)
    (location coin kitchen)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)