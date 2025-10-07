(define (problem coin_collector_numLocations7_numDistractorItems0_seed62)
  (:domain coin-collector)
  (:objects
    kitchen pantry living_room corridor backyard bathroom bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen living_room south)
    (connected kitchen corridor east)
    (connected pantry kitchen south)
    (connected living_room kitchen north)
    (connected living_room backyard east)
    (connected living_room bathroom west)
    (connected corridor kitchen west)
    (connected corridor backyard south)
    (connected corridor bedroom east)
    (connected backyard living_room west)
    (connected backyard corridor north)
    (connected bathroom living_room east)
    (connected bedroom corridor west)
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