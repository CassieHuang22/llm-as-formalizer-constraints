(define (problem coin_collector_numLocations11_numDistractorItems0_seed51)
;; CONSTRAINT The coin is in the supermarket.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor living_room backyard laundry_room bedroom bathroom driveway street supermarket - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen corridor east)
    (connected pantry kitchen north)
    (connected corridor kitchen west)
    (connected corridor living_room north)
    (connected corridor backyard south)
    (connected corridor laundry_room east)
    (connected living_room corridor south)
    (connected living_room bedroom north)
    (connected living_room bathroom east)
    (connected backyard corridor north)
    (connected backyard driveway south)
    (connected backyard street east)
    (connected laundry_room corridor west)
    (connected laundry_room bathroom north)
    (connected bedroom living_room south)
    (connected bathroom living_room west)
    (connected bathroom laundry_room south)
    (connected driveway backyard north)
    (connected street backyard west)
    (connected street supermarket south)
    (connected supermarket street north)
;; BEGIN EDIT
    (location coin supermarket)
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