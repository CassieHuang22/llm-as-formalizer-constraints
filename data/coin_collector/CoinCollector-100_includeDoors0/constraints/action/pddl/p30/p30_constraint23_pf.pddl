(define (problem coin_collector_numLocations7_numDistractorItems0_seed51)
;; CONSTRAINT You must visit pantry three times before going to the living room.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor living_room bedroom backyard bathroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen corridor east)
    (connected pantry kitchen north)
    (connected corridor kitchen west)
    (connected corridor living_room east)
    (connected living_room corridor west)
    (connected living_room bedroom north)
    (connected living_room backyard south)
    (connected living_room bathroom east)
    (connected bedroom living_room south)
    (connected backyard living_room north)
    (connected bathroom living_room west)
    (location coin bathroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (first-room pantry)
    (second-room living_room)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)