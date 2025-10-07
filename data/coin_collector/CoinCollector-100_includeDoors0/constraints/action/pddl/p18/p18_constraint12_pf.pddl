(define (problem coin_collector_numLocations11_numDistractorItems0_seed78)
;; CONSTRAINT You must visit the supermarket twice.
  (:domain coin-collector)
  (:objects
    kitchen corridor laundry_room pantry backyard bathroom bedroom living_room driveway street supermarket - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor south)
    (connected kitchen laundry_room east)
    (connected kitchen pantry west)
    (connected corridor kitchen north)
    (connected corridor backyard south)
    (connected corridor bathroom east)
    (connected corridor bedroom west)
    (connected laundry_room kitchen west)
    (connected laundry_room bathroom south)
    (connected pantry kitchen east)
    (connected backyard corridor north)
    (connected backyard living_room south)
    (connected backyard driveway east)
    (connected backyard street west)
    (connected bathroom corridor west)
    (connected bathroom laundry_room north)
    (connected bedroom corridor east)
    (connected living_room backyard north)
    (connected driveway backyard west)
    (connected street backyard east)
    (connected street supermarket south)
    (connected supermarket street north)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (must-visit supermarket)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)