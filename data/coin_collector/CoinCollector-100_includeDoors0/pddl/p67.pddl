(define (problem coin_collector_numLocations5_numDistractorItems0_seed21)
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry backyard bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor north)
    (connected kitchen pantry south)
    (connected corridor kitchen south)
    (connected corridor backyard north)
    (connected corridor bedroom west)
    (connected pantry kitchen north)
    (connected backyard corridor south)
    (connected bedroom corridor east)
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