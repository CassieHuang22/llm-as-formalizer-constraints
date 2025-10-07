(define (problem coin_collector_numLocations9_numDistractorItems0_seed95)
;; CONSTRAINT You start in the bathroom.
  (:domain coin-collector)
  (:objects
    kitchen living_room pantry laundry_room backyard corridor driveway bedroom bathroom - room
    north south east west - direction
    coin - item
  )
  (:init
;; BEGIN EDIT
    (at bathroom)
;; END EDIT
    (connected kitchen living_room north)
    (connected kitchen pantry east)
    (connected kitchen laundry_room west)
    (connected living_room kitchen south)
    (connected living_room backyard north)
    (connected living_room corridor west)
    (connected pantry kitchen west)
    (connected laundry_room kitchen east)
    (connected laundry_room corridor north)
    (connected backyard living_room south)
    (connected backyard driveway north)
    (connected corridor living_room east)
    (connected corridor laundry_room south)
    (connected corridor bedroom north)
    (connected corridor bathroom west)
    (connected driveway backyard south)
    (connected bedroom corridor south)
    (connected bathroom corridor east)
    (location coin driveway)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)