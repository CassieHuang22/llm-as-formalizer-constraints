(define (problem coin_collector_numLocations3_numDistractorItems0_seed33)
;; CONSTRAINT You must take exactly 2 move actions before taking any coin.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor - room
    north south east west - direction
    coin - item
;; BEGIN ADD
    step1 step2 step3 - step
;; END ADD
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen corridor south)
    (connected pantry kitchen south)
    (connected corridor kitchen north)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (current step1)
    (next step1 step2)
    (next step2 step3)
    (final-step step3)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)