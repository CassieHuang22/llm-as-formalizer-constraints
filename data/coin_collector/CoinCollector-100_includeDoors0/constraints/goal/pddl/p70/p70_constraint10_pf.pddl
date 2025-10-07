(define (problem coin_collector_numLocations7_numDistractorItems0_seed36)
;; CONSTRAINT Without taking the coin, you must be in the living room to end the task.
  (:domain coin-collector)
  (:objects
    kitchen living_room pantry corridor bedroom bathroom backyard - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen living_room north)
    (connected kitchen pantry south)
    (connected kitchen corridor west)
    (connected living_room kitchen south)
    (connected living_room bedroom east)
    (connected living_room bathroom west)
    (connected pantry kitchen north)
    (connected corridor kitchen east)
    (connected corridor bathroom north)
    (connected corridor backyard west)
    (connected bedroom living_room west)
    (connected bathroom living_room east)
    (connected bathroom corridor south)
    (connected backyard corridor east)
    (location coin living_room)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
;; BEGIN EDIT
    (and 
      (not (taken coin))
      (at living_room)
    )
;; END EDIT
  )
)