(define (problem coin_collector_numLocations7_numDistractorItems0_seed78)
;; CONSTRAINT You can't pick up any coin if you haven't been to the bedroom.
  (:domain coin-collector)
  (:objects
    kitchen pantry living_room backyard corridor bedroom bathroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen living_room east)
    (connected kitchen backyard west)
    (connected pantry kitchen south)
    (connected living_room kitchen west)
    (connected backyard kitchen east)
    (connected backyard corridor south)
    (connected corridor backyard north)
    (connected corridor bedroom south)
    (connected corridor bathroom west)
    (connected bedroom corridor north)
    (connected bathroom corridor east)
    (location coin backyard)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (must-visit-room bedroom)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)