(define (problem coin_collector_numLocations7_numDistractorItems0_seed58)
  (:domain coin-collector)
  (:objects
    kitchen backyard pantry bathroom living_room bedroom corridor - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard north)
    (connected kitchen pantry east)
    (connected kitchen bathroom west)
    (connected backyard kitchen south)
    (connected backyard living_room west)
    (connected pantry kitchen west)
    (connected bathroom kitchen east)
    (connected bathroom living_room north)
    (connected living_room backyard east)
    (connected living_room bathroom south)
    (connected living_room bedroom north)
    (connected living_room corridor west)
    (connected bedroom living_room south)
    (connected corridor living_room east)
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