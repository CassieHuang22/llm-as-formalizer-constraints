(define (problem coin_collector_numLocations5_numDistractorItems0_seed9)
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor backyard bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen corridor south)
    (connected kitchen backyard east)
    (connected pantry kitchen south)
    (connected corridor kitchen north)
    (connected corridor bedroom west)
    (connected backyard kitchen west)
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