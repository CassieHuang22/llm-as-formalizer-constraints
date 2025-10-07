(define (problem coin_collector_numLocations11_numDistractorItems0_seed75)
;; CONSTRAINT You must take exactly 6 move actions before taking any coin.
  (:domain coin-collector)
  (:objects
    kitchen living_room pantry corridor bathroom backyard driveway bedroom laundry_room street supermarket - room
    north south east west - direction
    coin - item
;; BEGIN ADD
    step1 step2 step3 step4 step5 step6 step7 - step
;; END ADD
  )
  (:init
    (at kitchen)
    (connected kitchen living_room north)
    (connected kitchen pantry south)
    (connected kitchen corridor east)
    (connected living_room kitchen south)
    (connected living_room bathroom east)
    (connected living_room backyard west)
    (connected pantry kitchen north)
    (connected corridor kitchen west)
    (connected corridor bathroom north)
    (connected corridor driveway south)
    (connected corridor bedroom east)
    (connected bathroom living_room west)
    (connected bathroom corridor south)
    (connected bathroom laundry_room north)
    (connected backyard living_room east)
    (connected backyard street south)
    (connected driveway corridor north)
    (connected bedroom corridor west)
    (connected laundry_room bathroom south)
    (connected street backyard north)
    (connected street supermarket south)
    (connected supermarket street north)
    (location coin bedroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (current step1)
    (next step1 step2) (next step2 step3) (next step3 step4) (next step4 step5) (next step5 step6) (next step6 step7)
    (final-step step7)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)