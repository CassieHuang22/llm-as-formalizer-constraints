(define (problem coin_collector_numLocations9_numDistractorItems0_seed87)
;; CONSTRAINT There is a decoy coin in the bathroom.
  (:domain coin-collector)
  (:objects
    kitchen living_room pantry bathroom bedroom corridor driveway backyard laundry_room - room
    north south east west - direction
;; BEGIN EDIT
    coin decoy_coin - item
;; END EDIT
  )
  (:init
    (at kitchen)
    (connected kitchen living_room south)
    (connected kitchen pantry east)
    (connected living_room kitchen north)
    (connected living_room bathroom east)
    (connected living_room bedroom west)
    (connected pantry kitchen west)
    (connected bathroom living_room west)
    (connected bathroom corridor south)
    (connected bedroom living_room east)
    (connected corridor bathroom north)
    (connected corridor driveway south)
    (connected corridor backyard east)
    (connected corridor laundry_room west)
    (connected driveway corridor north)
    (connected backyard corridor west)
    (connected laundry_room corridor east)
    (location coin kitchen)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (location decoy_coin bathroom)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)