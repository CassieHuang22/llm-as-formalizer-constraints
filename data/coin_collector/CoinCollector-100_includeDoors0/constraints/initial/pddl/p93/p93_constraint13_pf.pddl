(define (problem coin_collector_numLocations9_numDistractorItems0_seed44)
;; CONSTRAINT The coin is in the laundry room.
  (:domain coin-collector)
  (:objects
    kitchen bathroom pantry laundry_room backyard corridor driveway living_room bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen bathroom north)
    (connected kitchen pantry south)
    (connected kitchen laundry_room east)
    (connected kitchen backyard west)
    (connected bathroom kitchen south)
    (connected bathroom corridor east)
    (connected pantry kitchen north)
    (connected laundry_room kitchen west)
    (connected laundry_room corridor north)
    (connected backyard kitchen east)
    (connected backyard driveway north)
    (connected backyard living_room south)
    (connected corridor bathroom west)
    (connected corridor laundry_room south)
    (connected driveway backyard south)
    (connected living_room backyard north)
    (connected living_room bedroom west)
    (connected bedroom living_room east)
;; BEGIN EDIT
    (location coin laundry_room)
;; END EDIT
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)