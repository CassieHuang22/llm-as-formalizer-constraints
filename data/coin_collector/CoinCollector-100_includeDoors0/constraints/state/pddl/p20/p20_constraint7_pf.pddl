(define (problem coin_collector_numLocations11_numDistractorItems0_seed61)
;; CONSTRAINT You cannot be more than six rooms away from the kitchen.
  (:domain coin-collector)
  (:objects
    kitchen backyard corridor pantry living_room street driveway bathroom supermarket bedroom laundry_room - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard north)
    (connected kitchen corridor south)
    (connected kitchen pantry east)
    (connected backyard kitchen south)
    (connected backyard living_room east)
    (connected backyard street west)
    (connected corridor kitchen north)
    (connected corridor driveway south)
    (connected corridor bathroom west)
    (connected pantry kitchen west)
    (connected living_room backyard west)
    (connected street backyard east)
    (connected street supermarket north)
    (connected driveway corridor north)
    (connected bathroom corridor east)
    (connected bathroom bedroom north)
    (connected bathroom laundry_room west)
    (connected supermarket street south)
    (connected bedroom bathroom south)
    (connected laundry_room bathroom east)
    (location coin driveway)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (within-distance-room backyard) (within-distance-room corridor) (within-distance-room pantry) (within-distance-room living_room)
    (within-distance-room street) (within-distance-room street) (within-distance-room driveway) (within-distance-room bathroom)
    (within-distance-room supermarket) (within-distance-room bedroom) (within-distance-room laundry-room)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)