(define (problem coin_collector_numLocations7_numDistractorItems0_seed1)
  (:domain coin-collector)
  (:objects
    kitchen bathroom backyard pantry corridor living_room bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen bathroom south)
    (connected kitchen backyard east)
    (connected kitchen pantry west)
    (connected bathroom kitchen north)
    (connected bathroom corridor east)
    (connected backyard kitchen west)
    (connected backyard corridor south)
    (connected backyard living_room east)
    (connected pantry kitchen east)
    (connected corridor bathroom west)
    (connected corridor backyard north)
    (connected living_room backyard west)
    (connected living_room bedroom east)
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