(define (problem coin_collector_numLocations7_numDistractorItems0_seed77)
  (:domain coin-collector)
  (:objects
    kitchen backyard pantry living_room bedroom bathroom corridor - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard south)
    (connected kitchen pantry west)
    (connected backyard kitchen north)
    (connected backyard living_room south)
    (connected pantry kitchen east)
    (connected living_room backyard north)
    (connected living_room bedroom east)
    (connected living_room bathroom west)
    (connected bedroom living_room west)
    (connected bedroom corridor south)
    (connected bathroom living_room east)
    (connected corridor bedroom north)
    (location coin bathroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)