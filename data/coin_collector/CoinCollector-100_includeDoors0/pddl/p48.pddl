(define (problem coin_collector_numLocations5_numDistractorItems0_seed18)
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry backyard bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor south)
    (connected kitchen pantry east)
    (connected corridor kitchen north)
    (connected corridor backyard east)
    (connected corridor bedroom west)
    (connected pantry kitchen west)
    (connected backyard corridor west)
    (connected bedroom corridor east)
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