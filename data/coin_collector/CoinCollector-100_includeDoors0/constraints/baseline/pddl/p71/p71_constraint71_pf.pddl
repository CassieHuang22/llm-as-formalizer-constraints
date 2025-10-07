(define (problem coin_collector_numLocations7_numDistractorItems0_seed83)
  (:domain coin-collector)
  (:objects
    kitchen pantry living_room backyard bedroom bathroom corridor - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen living_room east)
    (connected pantry kitchen north)
    (connected living_room kitchen west)
    (connected living_room backyard north)
    (connected living_room bedroom south)
    (connected living_room bathroom east)
    (connected backyard living_room south)
    (connected backyard corridor east)
    (connected bedroom living_room north)
    (connected bathroom living_room west)
    (connected bathroom corridor north)
    (connected corridor backyard west)
    (connected corridor bathroom south)
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