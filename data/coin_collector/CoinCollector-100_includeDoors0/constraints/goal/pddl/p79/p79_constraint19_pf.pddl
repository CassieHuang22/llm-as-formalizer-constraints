(define (problem coin_collector_numLocations11_numDistractorItems0_seed10)
;; CONSTRAINT You must take the coin and the salt shaker to end the task.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor laundry_room backyard living_room bathroom driveway street bedroom supermarket - room
    north south east west - direction
;; BEGIN EDIT
    coin salt_shaker - item
;; END EDIT
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen corridor west)
    (connected pantry kitchen north)
    (connected corridor kitchen east)
    (connected corridor laundry_room north)
    (connected corridor backyard south)
    (connected corridor living_room west)
    (connected laundry_room corridor south)
    (connected laundry_room bathroom west)
    (connected backyard corridor north)
    (connected backyard driveway south)
    (connected backyard street west)
    (connected living_room corridor east)
    (connected living_room bathroom north)
    (connected bathroom laundry_room east)
    (connected bathroom living_room south)
    (connected bathroom bedroom west)
    (connected driveway backyard north)
    (connected street backyard east)
    (connected street supermarket west)
    (connected bedroom bathroom east)
    (connected supermarket street east)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
;; BEGIN EDIT
    (and
      (taken coin)
      (taken salt_shaker)
    )
;; END EDIT
  )
)