(define (problem coin_collector_numLocations7_numDistractorItems0_seed71)
;; CONSTRAINT You can't go to the bedroom if you haven't been to the pantry. Also, you cannot pick up any coins if you haven't been to the backyard.
  (:domain coin-collector)
  (:objects
    kitchen pantry bathroom backyard living_room corridor bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen bathroom south)
    (connected kitchen backyard east)
    (connected kitchen living_room west)
    (connected pantry kitchen south)
    (connected bathroom kitchen north)
    (connected bathroom corridor west)
    (connected backyard kitchen west)
    (connected living_room kitchen east)
    (connected living_room corridor south)
    (connected living_room bedroom west)
    (connected corridor bathroom east)
    (connected corridor living_room north)
    (connected bedroom living_room east)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (must-visit-before-next pantry)
    (next-room bedroom)
    (must-visit-before-coin backyard)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)