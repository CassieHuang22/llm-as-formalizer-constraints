(define (problem coin_collector_numLocations9_numDistractorItems0_seed72)
;; CONSTRAINT Do not move into the living room.
  (:domain coin-collector)
  (:objects
    kitchen pantry living_room backyard laundry_room corridor driveway bathroom bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen living_room south)
    (connected kitchen backyard east)
    (connected kitchen laundry_room west)
    (connected pantry kitchen south)
    (connected living_room kitchen north)
    (connected living_room corridor east)
    (connected backyard kitchen west)
    (connected backyard corridor south)
    (connected backyard driveway east)
    (connected laundry_room kitchen east)
    (connected corridor living_room west)
    (connected corridor backyard north)
    (connected corridor bathroom south)
    (connected corridor bedroom east)
    (connected driveway backyard west)
    (connected bathroom corridor north)
    (connected bedroom corridor west)
    (location coin laundry_room)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (not-allowed-room living_room)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)