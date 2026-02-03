(define (problem coin_collector_numLocations9_numDistractorItems0_seed8)
;; CONSTRAINT After taking the coin, you must be in the laundry room to end the task.
  (:domain coin-collector)
  (:objects
    kitchen living_room corridor pantry bathroom backyard driveway laundry_room bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen living_room north)
    (connected kitchen corridor south)
    (connected kitchen pantry east)
    (connected kitchen bathroom west)
    (connected living_room kitchen south)
    (connected living_room backyard north)
    (connected corridor kitchen north)
    (connected corridor driveway south)
    (connected corridor laundry_room east)
    (connected corridor bedroom west)
    (connected pantry kitchen west)
    (connected bathroom kitchen east)
    (connected bathroom bedroom south)
    (connected backyard living_room south)
    (connected driveway corridor north)
    (connected laundry_room corridor west)
    (connected bedroom corridor east)
    (connected bedroom bathroom north)
    (location coin bathroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
;; BEGIN EDIT
    (and
      (taken coin)
      (at laundry_room)
    )
;; END EDIT
  )
)