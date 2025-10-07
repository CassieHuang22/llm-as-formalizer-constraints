(define (problem coin_collector_numLocations9_numDistractorItems0_seed91)
;; CONSTRAINT After taking the coin, you must be in the room furthest east and furthest north to end the task.
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry living_room laundry_room driveway bedroom bathroom backyard - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor north)
    (connected kitchen pantry south)
    (connected kitchen living_room east)
    (connected kitchen laundry_room west)
    (connected corridor kitchen south)
    (connected corridor driveway north)
    (connected corridor bedroom east)
    (connected corridor bathroom west)
    (connected pantry kitchen north)
    (connected living_room kitchen west)
    (connected living_room bedroom north)
    (connected living_room backyard south)
    (connected laundry_room kitchen east)
    (connected laundry_room bathroom north)
    (connected driveway corridor south)
    (connected bedroom corridor west)
    (connected bedroom living_room south)
    (connected bathroom corridor east)
    (connected bathroom laundry_room south)
    (connected backyard living_room north)
    (location coin living_room)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
;; BEGIN EDIT
    (and
      (taken coin)
      (at bedroom)
    )
;; END EDIT
  )
)