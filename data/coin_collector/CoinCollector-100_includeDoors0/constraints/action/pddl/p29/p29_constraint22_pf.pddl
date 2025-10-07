(define (problem coin_collector_numLocations7_numDistractorItems0_seed93)
;; CONSTRAINT You must visit the bedroom before the bathroom.
  (:domain coin-collector)
  (:objects
    kitchen corridor living_room pantry backyard bedroom bathroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor north)
    (connected kitchen living_room south)
    (connected kitchen pantry east)
    (connected kitchen backyard west)
    (connected corridor kitchen south)
    (connected corridor bedroom west)
    (connected living_room kitchen north)
    (connected pantry kitchen west)
    (connected backyard kitchen east)
    (connected bedroom corridor east)
    (connected bedroom bathroom north)
    (connected bathroom bedroom south)
    (location coin backyard)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (must-visit-before-next bedroom)
    (next-room bathroom)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)