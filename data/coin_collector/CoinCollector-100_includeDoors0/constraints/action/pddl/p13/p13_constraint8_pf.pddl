(define (problem coin_collector_numLocations9_numDistractorItems0_seed100)
;; CONSTRAINT You must take exactly 5 move actions before taking any coin.
  (:domain coin-collector)
  (:objects
    kitchen corridor backyard pantry laundry_room bedroom bathroom driveway living_room - room
    north south east west - direction
    coin - item
;; BEGIN ADD
    step1 step2 step3 step4 step5 step6 - step
;; END ADD
  )
  (:init
    (at kitchen)
    (connected kitchen corridor north)
    (connected kitchen backyard south)
    (connected kitchen pantry east)
    (connected kitchen laundry_room west)
    (connected corridor kitchen south)
    (connected corridor bedroom north)
    (connected corridor bathroom east)
    (connected corridor driveway west)
    (connected backyard kitchen north)
    (connected pantry kitchen west)
    (connected laundry_room kitchen east)
    (connected bedroom corridor south)
    (connected bathroom corridor west)
    (connected bathroom living_room east)
    (connected driveway corridor east)
    (connected living_room bathroom west)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (current step1)
    (next step1 step2) (next step2 step3) (next step3 step4) (next step4 step5) (next step5 step6)
    (final-step step6)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)