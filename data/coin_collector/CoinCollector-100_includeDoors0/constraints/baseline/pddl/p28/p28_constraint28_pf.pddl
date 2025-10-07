(define (problem coin_collector_numLocations5_numDistractorItems0_seed47)
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
    (connected kitchen corridor west)
    (connected backyard kitchen north)
    (connected pantry kitchen west)
    (connected corridor kitchen east)
    (connected corridor bedroom west)
    (connected bedroom corridor east)
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