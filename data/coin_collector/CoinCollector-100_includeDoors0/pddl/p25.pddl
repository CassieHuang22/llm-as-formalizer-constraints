(define (problem coin_collector_numLocations5_numDistractorItems0_seed24)
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry bedroom backyard - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor north)
    (connected kitchen pantry south)
    (connected corridor kitchen south)
    (connected corridor bedroom east)
    (connected corridor backyard west)
    (connected pantry kitchen north)
    (connected bedroom corridor west)
    (connected backyard corridor east)
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