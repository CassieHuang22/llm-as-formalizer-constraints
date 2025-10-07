(define (problem coin_collector_numLocations9_numDistractorItems0_seed24)
;; CONSTRAINT You can only move west or move east.
  (:domain coin-collector)
  (:objects
    kitchen pantry living_room bathroom bedroom corridor laundry_room backyard driveway - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen living_room south)
    (connected kitchen bathroom west)
    (connected pantry kitchen south)
    (connected living_room kitchen north)
    (connected living_room bedroom west)
    (connected bathroom kitchen east)
    (connected bathroom bedroom south)
    (connected bedroom living_room east)
    (connected bedroom bathroom north)
    (connected bedroom corridor west)
    (connected corridor bedroom east)
    (connected corridor laundry_room south)
    (connected corridor backyard west)
    (connected laundry_room corridor north)
    (connected backyard corridor east)
    (connected backyard driveway south)
    (connected driveway backyard north)
    (location coin backyard)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (allowed-direction west)
    (allowed-direction east)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)