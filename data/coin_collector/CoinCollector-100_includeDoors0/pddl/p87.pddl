(define (problem coin_collector_numLocations5_numDistractorItems0_seed48)
  (:domain coin-collector)
  (:objects
    kitchen pantry backyard corridor bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen backyard south)
    (connected pantry kitchen south)
    (connected backyard kitchen north)
    (connected backyard corridor east)
    (connected corridor backyard west)
    (connected corridor bedroom south)
    (connected bedroom corridor north)
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