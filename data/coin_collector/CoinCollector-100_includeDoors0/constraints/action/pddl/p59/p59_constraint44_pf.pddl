(define (problem coin_collector_numLocations11_numDistractorItems0_seed23)
;; CONSTRAINT Once you move into the living room, you cannot go back to it.
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry backyard bedroom laundry_room driveway street living_room supermarket bathroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor south)
    (connected kitchen pantry east)
    (connected corridor kitchen north)
    (connected corridor backyard south)
    (connected corridor bedroom east)
    (connected corridor laundry_room west)
    (connected pantry kitchen west)
    (connected backyard corridor north)
    (connected backyard driveway east)
    (connected backyard street west)
    (connected bedroom corridor west)
    (connected bedroom living_room east)
    (connected laundry_room corridor east)
    (connected driveway backyard west)
    (connected street backyard east)
    (connected street supermarket south)
    (connected living_room bedroom west)
    (connected living_room bathroom east)
    (connected supermarket street north)
    (connected bathroom living_room west)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (no-reentry-room living_room)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)