(define (problem coin_collector_numLocations7_numDistractorItems0_seed74)
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor bathroom living_room backyard bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen corridor south)
    (connected kitchen bathroom east)
    (connected kitchen living_room west)
    (connected pantry kitchen south)
    (connected corridor kitchen north)
    (connected corridor backyard south)
    (connected corridor bedroom west)
    (connected bathroom kitchen west)
    (connected living_room kitchen east)
    (connected living_room bedroom south)
    (connected backyard corridor north)
    (connected bedroom corridor east)
    (connected bedroom living_room north)
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