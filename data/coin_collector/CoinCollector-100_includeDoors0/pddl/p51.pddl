(define (problem coin_collector_numLocations7_numDistractorItems0_seed24)
  (:domain coin-collector)
  (:objects
    kitchen living_room corridor backyard pantry bedroom bathroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen living_room north)
    (connected kitchen corridor south)
    (connected kitchen backyard east)
    (connected kitchen pantry west)
    (connected living_room kitchen south)
    (connected living_room bedroom north)
    (connected corridor kitchen north)
    (connected corridor bathroom west)
    (connected backyard kitchen west)
    (connected pantry kitchen east)
    (connected bedroom living_room south)
    (connected bathroom corridor east)
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