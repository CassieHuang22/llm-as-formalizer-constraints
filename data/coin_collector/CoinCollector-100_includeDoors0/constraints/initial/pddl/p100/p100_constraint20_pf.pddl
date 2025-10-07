(define (problem coin_collector_numLocations11_numDistractorItems0_seed6)
;; CONSTRAINT There is another room, the game room, north of the pantry.
  (:domain coin-collector)
  (:objects
;; BEGIN EDIT
    kitchen pantry living_room backyard bathroom street corridor laundry_room supermarket driveway bedroom game_room - room
;; END EDIT
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen living_room west)
    (connected pantry kitchen south)
    (connected living_room kitchen east)
    (connected living_room backyard south)
    (connected living_room bathroom west)
    (connected backyard living_room north)
    (connected backyard street east)
    (connected backyard corridor west)
    (connected bathroom living_room east)
    (connected bathroom corridor south)
    (connected bathroom laundry_room west)
    (connected street backyard west)
    (connected street supermarket east)
    (connected corridor backyard east)
    (connected corridor bathroom north)
    (connected corridor driveway south)
    (connected corridor bedroom west)
    (connected laundry_room bathroom east)
    (connected supermarket street west)
    (connected driveway corridor north)
    (connected bedroom corridor east)
;; BEGIN ADD
    (connected pantry game_room north)
    (connected game_room pantry south)
;; END ADD
    (location coin living_room)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)