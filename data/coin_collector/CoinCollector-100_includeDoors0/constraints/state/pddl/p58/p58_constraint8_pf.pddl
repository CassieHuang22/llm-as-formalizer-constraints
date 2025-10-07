(define (problem coin_collector_numLocations11_numDistractorItems0_seed54)
;; CONSTRAINT There is now a closed door between the kitchen and pantry. To open the door there is now the (open room1 room2 direction reverse-direction) action.
  (:domain coin-collector)
  (:objects
    kitchen bathroom corridor pantry backyard laundry_room bedroom driveway living_room street supermarket - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen bathroom north)
    (connected kitchen corridor south)
;; BEGIN EDIT
    (closed-door kitchen pantry east)
;; END EDIT
    (connected kitchen backyard west)
    (connected bathroom kitchen south)
    (connected bathroom laundry_room east)
    (connected corridor kitchen north)
    (connected corridor bedroom south)
    (connected corridor driveway west)
;; BEGIN EDIT
    (closed-door pantry kitchen west)
;; END EDIT
    (connected backyard kitchen east)
    (connected backyard driveway south)
    (connected laundry_room bathroom west)
    (connected bedroom corridor north)
    (connected bedroom living_room east)
    (connected driveway corridor east)
    (connected driveway backyard north)
    (connected driveway street south)
    (connected living_room bedroom west)
    (connected street driveway north)
    (connected street supermarket south)
    (connected supermarket street north)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)