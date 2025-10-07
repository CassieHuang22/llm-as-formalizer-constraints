(define (problem coin_collector_numLocations7_numDistractorItems0_seed64)
;; CONSTRAINT You start in the living room.
  (:domain coin-collector)
  (:objects
    kitchen pantry backyard living_room corridor bedroom bathroom - room
    north south east west - direction
    coin - item
  )
  (:init
;; BEGIN EDIT
    (at living_room)
;; END EDIT
    (connected kitchen pantry north)
    (connected kitchen backyard south)
    (connected kitchen living_room west)
    (connected pantry kitchen south)
    (connected backyard kitchen north)
    (connected backyard corridor south)
    (connected living_room kitchen east)
    (connected living_room bedroom west)
    (connected corridor backyard north)
    (connected corridor bathroom east)
    (connected bedroom living_room east)
    (connected bathroom corridor west)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)