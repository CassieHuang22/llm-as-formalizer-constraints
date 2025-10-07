(define (problem coin_collector_numLocations9_numDistractorItems0_seed61)
;; CONSTRAINT You can't go to the driveway without visiting the bedroom.
  (:domain coin-collector)
  (:objects
    kitchen backyard laundry_room bathroom pantry driveway corridor living_room bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard north)
    (connected kitchen laundry_room south)
    (connected kitchen bathroom east)
    (connected kitchen pantry west)
    (connected backyard kitchen south)
    (connected backyard driveway north)
    (connected backyard corridor east)
    (connected laundry_room kitchen north)
    (connected bathroom kitchen west)
    (connected bathroom corridor north)
    (connected bathroom living_room south)
    (connected pantry kitchen east)
    (connected driveway backyard south)
    (connected corridor backyard west)
    (connected corridor bathroom south)
    (connected living_room bathroom north)
    (connected living_room bedroom east)
    (connected bedroom living_room west)
    (location coin driveway)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (must-visit-before-next bedroom)
    (next-room driveway)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)