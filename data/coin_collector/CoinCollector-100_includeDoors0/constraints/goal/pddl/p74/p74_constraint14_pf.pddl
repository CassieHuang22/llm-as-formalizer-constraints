(define (problem coin_collector_numLocations9_numDistractorItems0_seed79)
;; CONSTRAINT Without taking the coin, you must be the backyard to end the task.
  (:domain coin-collector)
  (:objects
    kitchen backyard pantry corridor driveway living_room bathroom bedroom laundry_room - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard north)
    (connected kitchen pantry east)
    (connected backyard kitchen south)
    (connected backyard corridor north)
    (connected backyard driveway east)
    (connected backyard living_room west)
    (connected pantry kitchen west)
    (connected corridor backyard south)
    (connected corridor bathroom west)
    (connected driveway backyard west)
    (connected living_room backyard east)
    (connected living_room bathroom north)
    (connected living_room bedroom south)
    (connected bathroom corridor east)
    (connected bathroom living_room south)
    (connected bathroom laundry_room north)
    (connected bedroom living_room north)
    (connected laundry_room bathroom south)
    (location coin bathroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
;; BEGIN EDIT
    (and
      (not (taken coin))
      (at backyard)
    )
;; END EDIT
  )
)