(define (problem coin_collector_numLocations11_numDistractorItems0_seed90)
;; CONSTRAINT There is a decoy coin in the street.
  (:domain coin-collector)
  (:objects
    kitchen pantry bathroom backyard laundry_room living_room corridor street bedroom driveway supermarket - room
    north south east west - direction
;; BEGIN EDIT
    coin decoy_coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen bathroom south)
    (connected kitchen backyard west)
    (connected pantry kitchen south)
    (connected bathroom kitchen north)
    (connected bathroom laundry_room south)
    (connected bathroom living_room west)
    (connected backyard kitchen east)
    (connected backyard corridor north)
    (connected backyard living_room south)
    (connected backyard street west)
    (connected laundry_room bathroom north)
    (connected living_room bathroom east)
    (connected living_room backyard north)
    (connected living_room bedroom west)
    (connected corridor backyard south)
    (connected corridor driveway north)
    (connected street backyard east)
    (connected street supermarket west)
    (connected bedroom living_room east)
    (connected driveway corridor south)
    (connected supermarket street east)
    (location coin driveway)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (location decoy_coin street)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)