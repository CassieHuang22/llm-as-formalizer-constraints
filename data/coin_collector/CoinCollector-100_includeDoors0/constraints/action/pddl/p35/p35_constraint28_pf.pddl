(define (problem coin_collector_numLocations9_numDistractorItems0_seed68)
;; CONSTRAINT If you visit the corridor, you must visit the living room directly after.
  (:domain coin-collector)
  (:objects
    kitchen laundry_room bathroom corridor pantry living_room driveway backyard bedroom - room
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
    (connected bathroom living_room west)
    (connected corridor kitchen west)
    (connected corridor driveway north)
    (connected pantry kitchen east)
    (connected living_room bathroom east)
    (connected living_room backyard south)
    (connected living_room bedroom west)
    (connected driveway corridor south)
    (connected backyard living_room north)
    (connected bedroom living_room east)
    (location coin bathroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (first-room corridor)
    (second-room living_room)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)