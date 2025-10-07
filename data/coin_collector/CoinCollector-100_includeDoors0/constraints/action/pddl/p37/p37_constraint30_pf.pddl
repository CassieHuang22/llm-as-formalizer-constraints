(define (problem coin_collector_numLocations11_numDistractorItems0_seed43)
;; CONSTRAINT If you visit the corridor, you must visit the pantry directly after.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor laundry_room driveway living_room bathroom backyard bedroom street supermarket - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen corridor west)
    (connected pantry kitchen north)
    (connected corridor kitchen east)
    (connected corridor laundry_room north)
    (connected corridor driveway south)
    (connected corridor living_room west)
    (connected laundry_room corridor south)
    (connected laundry_room bathroom west)
    (connected driveway corridor north)
    (connected driveway backyard west)
    (connected living_room corridor east)
    (connected living_room bathroom north)
    (connected living_room backyard south)
    (connected living_room bedroom west)
    (connected bathroom laundry_room east)
    (connected bathroom living_room south)
    (connected backyard driveway east)
    (connected backyard living_room north)
    (connected backyard street south)
    (connected bedroom living_room east)
    (connected street backyard north)
    (connected street supermarket west)
    (connected supermarket street east)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (first-room corridor)
    (second-room pantry)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)