(define (problem coin_collector_numLocations9_numDistractorItems0_seed78)
;; CONSTRAINT You cannot be more than five rooms away from the kitchen.
  (:domain coin-collector)
  (:objects
    kitchen living_room pantry bedroom backyard corridor laundry_room driveway bathroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen living_room south)
    (connected kitchen pantry west)
    (connected living_room kitchen north)
    (connected living_room bedroom south)
    (connected living_room backyard east)
    (connected pantry kitchen east)
    (connected bedroom living_room north)
    (connected bedroom corridor west)
    (connected backyard living_room west)
    (connected corridor bedroom east)
    (connected corridor laundry_room north)
    (connected corridor driveway south)
    (connected corridor bathroom west)
    (connected laundry_room corridor south)
    (connected driveway corridor north)
    (connected bathroom corridor east)
    (location coin driveway)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (within-distance-room living_room) (within-distnace-room pantry) (within-distance-room bedroom) (within-distance-room backyard)
    (within-distance-room corridor) (within-distance-room laundry_room) (within-distance-room driveway) (within-distance-room bathroom)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)