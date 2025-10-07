(define (problem coin_collector_numLocations7_numDistractorItems0_seed99)
  (:domain coin-collector)
  (:objects
    kitchen corridor living_room pantry backyard bathroom bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor north)
    (connected kitchen living_room south)
    (connected kitchen pantry west)
    (connected corridor kitchen south)
    (connected corridor backyard north)
    (connected corridor bathroom east)
    (connected living_room kitchen north)
    (connected living_room bedroom east)
    (connected pantry kitchen east)
    (connected backyard corridor south)
    (connected bathroom corridor west)
    (connected bedroom living_room west)
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