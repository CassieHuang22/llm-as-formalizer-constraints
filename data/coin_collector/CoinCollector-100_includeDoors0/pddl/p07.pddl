(define (problem coin_collector_numLocations5_numDistractorItems0_seed97)
  (:domain coin-collector)
  (:objects
    kitchen backyard pantry corridor bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard south)
    (connected kitchen pantry east)
    (connected backyard kitchen north)
    (connected backyard corridor south)
    (connected pantry kitchen west)
    (connected corridor backyard north)
    (connected corridor bedroom south)
    (connected bedroom corridor north)
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