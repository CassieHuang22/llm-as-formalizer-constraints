(define (problem coin_collector_numLocations9_numDistractorItems0_seed34)
;; CONSTRAINT If you take the coin, you must go to the kitchen directly after.
  (:domain coin-collector)
  (:objects
    kitchen bathroom pantry corridor living_room bedroom laundry_room backyard driveway - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen bathroom north)
    (connected kitchen pantry south)
    (connected kitchen corridor east)
    (connected bathroom kitchen south)
    (connected bathroom living_room east)
    (connected pantry kitchen north)
    (connected corridor kitchen west)
    (connected corridor living_room north)
    (connected corridor bedroom south)
    (connected corridor laundry_room east)
    (connected living_room bathroom west)
    (connected living_room corridor south)
    (connected living_room backyard east)
    (connected bedroom corridor north)
    (connected laundry_room corridor west)
    (connected backyard living_room west)
    (connected backyard driveway east)
    (connected driveway backyard west)
    (location coin living_room)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (room-after-coin kitchen)
;; END ADD
  )
  (:goal 
;; BEGIN EDIT
    (and
      (taken coin)
      (at kitchen)
    )
  )
)