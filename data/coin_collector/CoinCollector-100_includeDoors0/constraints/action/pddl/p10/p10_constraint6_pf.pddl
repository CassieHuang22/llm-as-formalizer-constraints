(define (problem coin_collector_numLocations7_numDistractorItems0_seed60)
;; CONSTRAINT You must visit the bedroom twice.
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry bathroom bedroom backyard living_room - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor south)
    (connected kitchen pantry east)
    (connected corridor kitchen north)
    (connected corridor bathroom south)
    (connected corridor bedroom east)
    (connected corridor backyard west)
    (connected pantry kitchen west)
    (connected bathroom corridor north)
    (connected bathroom living_room east)
    (connected bedroom corridor west)
    (connected bedroom living_room south)
    (connected backyard corridor east)
    (connected living_room bathroom west)
    (connected living_room bedroom north)
    (location coin bedroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (must-visit bedroom)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)