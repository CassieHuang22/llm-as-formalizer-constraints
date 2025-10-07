(define (problem coin_collector_numLocations7_numDistractorItems0_seed23)
  (:domain coin-collector)
  (:objects
    kitchen backyard corridor pantry living_room bedroom bathroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard south)
    (connected kitchen corridor east)
    (connected kitchen pantry west)
    (connected backyard kitchen north)
    (connected backyard living_room east)
    (connected corridor kitchen west)
    (connected corridor bedroom north)
    (connected corridor living_room south)
    (connected pantry kitchen east)
    (connected living_room backyard west)
    (connected living_room corridor north)
    (connected bedroom corridor south)
    (connected bedroom bathroom north)
    (connected bathroom bedroom south)
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