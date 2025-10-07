(define (problem coin_collector_numLocations11_numDistractorItems0_seed4)
;; CONSTRAINT You start in the supermarket.
  (:domain coin-collector)
  (:objects
    kitchen backyard laundry_room pantry corridor street bathroom driveway bedroom supermarket living_room - room
    north south east west - direction
    coin - item
  )
  (:init
;; BEGIN EDIT
    (at supermarket)
;; END EDIT
    (connected kitchen backyard north)
    (connected kitchen laundry_room south)
    (connected kitchen pantry east)
    (connected kitchen corridor west)
    (connected backyard kitchen south)
    (connected backyard street north)
    (connected laundry_room kitchen north)
    (connected pantry kitchen west)
    (connected corridor kitchen east)
    (connected corridor bathroom north)
    (connected corridor driveway south)
    (connected corridor bedroom west)
    (connected street backyard south)
    (connected street supermarket north)
    (connected bathroom corridor south)
    (connected bathroom living_room west)
    (connected driveway corridor north)
    (connected bedroom corridor east)
    (connected bedroom living_room north)
    (connected supermarket street south)
    (connected living_room bathroom east)
    (connected living_room bedroom south)
    (location coin street)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)