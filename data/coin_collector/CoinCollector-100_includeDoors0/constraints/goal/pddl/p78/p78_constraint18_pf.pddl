(define (problem coin_collector_numLocations11_numDistractorItems0_seed69)
;; CONSTRAINT Without taking the coin, you must be in the street to end the task
  (:domain coin-collector)
  (:objects
    kitchen pantry living_room bathroom corridor laundry_room bedroom driveway backyard street supermarket - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen living_room west)
    (connected pantry kitchen south)
    (connected living_room kitchen east)
    (connected living_room bathroom south)
    (connected living_room corridor west)
    (connected bathroom living_room north)
    (connected bathroom laundry_room south)
    (connected bathroom bedroom west)
    (connected corridor living_room east)
    (connected corridor driveway north)
    (connected corridor bedroom south)
    (connected corridor backyard west)
    (connected laundry_room bathroom north)
    (connected bedroom bathroom east)
    (connected bedroom corridor north)
    (connected driveway corridor south)
    (connected backyard corridor east)
    (connected backyard street south)
    (connected street backyard north)
    (connected street supermarket south)
    (connected supermarket street north)
    (location coin supermarket)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
;; BEGIN EDIT
    (and
      (not (taken coin))
      (at street)
    )
;; END EDIT
  )
)