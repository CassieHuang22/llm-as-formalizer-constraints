(define (problem coin_collector_numLocations5_numDistractorItems0_seed63)
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor bedroom backyard - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen corridor south)
    (connected pantry kitchen south)
    (connected corridor kitchen north)
    (connected corridor bedroom south)
    (connected corridor backyard west)
    (connected bedroom corridor north)
    (connected backyard corridor east)
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