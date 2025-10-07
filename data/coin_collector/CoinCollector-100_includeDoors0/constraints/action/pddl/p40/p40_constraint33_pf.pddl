(define (problem coin_collector_numLocations11_numDistractorItems0_seed31)
;; CONSTRAINT If you take the coin, you must go to the living room directly after.
  (:domain coin-collector)
  (:objects
    kitchen laundry_room bathroom corridor pantry living_room bedroom driveway backyard street supermarket - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen laundry_room north)
    (connected kitchen bathroom south)
    (connected kitchen corridor east)
    (connected kitchen pantry west)
    (connected laundry_room kitchen south)
    (connected bathroom kitchen north)
    (connected bathroom living_room south)
    (connected corridor kitchen west)
    (connected corridor bedroom north)
    (connected corridor driveway east)
    (connected pantry kitchen east)
    (connected living_room bathroom north)
    (connected living_room backyard west)
    (connected bedroom corridor south)
    (connected driveway corridor west)
    (connected backyard living_room east)
    (connected backyard street south)
    (connected street backyard north)
    (connected street supermarket west)
    (connected supermarket street east)
    (location coin driveway)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (room-after-coin living_room)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)