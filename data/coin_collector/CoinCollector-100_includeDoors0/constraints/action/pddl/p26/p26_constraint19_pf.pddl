(define (problem coin_collector_numLocations5_numDistractorItems0_seed80)
;; CONSTRAINT You can't go to the bedroom if you haven't been to the backyard.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor bedroom backyard - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen corridor east)
    (connected pantry kitchen north)
    (connected corridor kitchen west)
    (connected corridor bedroom north)
    (connected corridor backyard south)
    (connected bedroom corridor south)
    (connected backyard corridor north)
    (location coin bedroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (must-visit-before-next backyard)
    (next-room bedroom)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)