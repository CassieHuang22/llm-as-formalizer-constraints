(define (problem coin_collector_numLocations7_numDistractorItems0_seed85)
;; CONSTRAINT You can only move north or move south.
  (:domain coin-collector)
  (:objects
    kitchen pantry bathroom living_room corridor bedroom backyard - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry east)
    (connected kitchen bathroom west)
    (connected pantry kitchen west)
    (connected bathroom kitchen east)
    (connected bathroom living_room south)
    (connected bathroom corridor west)
    (connected living_room bathroom north)
    (connected living_room bedroom east)
    (connected living_room backyard west)
    (connected corridor bathroom east)
    (connected corridor backyard south)
    (connected bedroom living_room west)
    (connected backyard living_room east)
    (connected backyard corridor north)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (allowed-direction north)
    (allowed-direction south)
  )
  (:goal 
    (taken coin)
  )
)