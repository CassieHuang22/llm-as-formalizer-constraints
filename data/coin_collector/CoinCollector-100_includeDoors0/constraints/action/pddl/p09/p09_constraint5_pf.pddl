(define (problem coin_collector_numLocations7_numDistractorItems0_seed70)
;; CONSTRAINT You must take exactly 4 move actions before taking any coin.
  (:domain coin-collector)
  (:objects
    kitchen living_room pantry bathroom backyard corridor bedroom - room
    north south east west - direction
    coin - item
;; BEGIN ADD
    step1 step2 step3 step4 step5 - step
;; END ADD
  )
  (:init
    (at kitchen)
    (connected kitchen living_room north)
    (connected kitchen pantry south)
    (connected kitchen bathroom west)
    (connected living_room kitchen south)
    (connected living_room backyard north)
    (connected pantry kitchen north)
    (connected bathroom kitchen east)
    (connected backyard living_room south)
    (connected backyard corridor west)
    (connected corridor backyard east)
    (connected corridor bedroom north)
    (connected bedroom corridor south)
    (location coin kitchen)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (current step1)
    (next step1 step2)
    (next step2 step3)
    (next step3 step4)
    (next step4 step5)
    (final-step step5)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)