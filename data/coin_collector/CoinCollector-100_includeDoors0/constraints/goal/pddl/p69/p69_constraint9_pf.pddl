(define (problem coin_collector_numLocations7_numDistractorItems0_seed19)
;; CONSTRAINT After taking the coin, you must be in the bathroom to end the task.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor bathroom bedroom living_room backyard - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen corridor west)
    (connected pantry kitchen north)
    (connected corridor kitchen east)
    (connected corridor bathroom north)
    (connected corridor bedroom south)
    (connected bathroom corridor south)
    (connected bathroom living_room north)
    (connected bedroom corridor north)
    (connected living_room bathroom south)
    (connected living_room backyard north)
    (connected backyard living_room south)
    (location coin bedroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
;; BEGIN EDIT
    (and
      (taken coin)
      (at bathroom)
    )
;; END EDIT
  )
)