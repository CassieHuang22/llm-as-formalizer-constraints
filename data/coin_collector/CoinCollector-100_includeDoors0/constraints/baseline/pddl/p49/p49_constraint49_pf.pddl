(define (problem coin_collector_numLocations7_numDistractorItems0_seed97)
  (:domain coin-collector)
  (:objects
    kitchen bathroom living_room backyard pantry corridor bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen bathroom north)
    (connected kitchen living_room south)
    (connected kitchen backyard east)
    (connected kitchen pantry west)
    (connected bathroom kitchen south)
    (connected bathroom corridor east)
    (connected living_room kitchen north)
    (connected backyard kitchen west)
    (connected backyard corridor north)
    (connected pantry kitchen east)
    (connected corridor bathroom west)
    (connected corridor backyard south)
    (connected corridor bedroom north)
    (connected bedroom corridor south)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)