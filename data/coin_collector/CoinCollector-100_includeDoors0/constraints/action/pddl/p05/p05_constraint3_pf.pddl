(define (problem coin_collector_numLocations5_numDistractorItems0_seed68)
;; CONSTRAINT You must take exactly 3 move actions before taking any coin.
  (:domain coin-collector)
  (:objects
    kitchen backyard pantry corridor bedroom - room
    north south east west - direction
    coin - item
;; BEGIN ADD
    step1 step2 step3 step4 - step
;; END ADD
  )
  (:init
    (at kitchen)
    (connected kitchen backyard east)
    (connected kitchen pantry west)
    (connected backyard kitchen west)
    (connected backyard corridor north)
    (connected pantry kitchen east)
    (connected corridor backyard south)
    (connected corridor bedroom west)
    (connected bedroom corridor east)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (current step1)
    (next step1 step2)
    (next step2 step3)
    (next step3 step4)
    (final-step step4)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)