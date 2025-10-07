(define (problem coin_collector_numLocations5_numDistractorItems0_seed97)
;; CONSTRAINT Each room has their own ID number (kitchen=1, pantry=2, corridor=3, backyard=4, bedroom=5, living room = 6, bathroom=7, laundry room=8, driveway=9, street=10, supermarket=11) the sum of all IDs for the rooms you visit, including the starting room, cannot exceed 10.
  (:domain coin-collector)
  (:objects
    kitchen backyard pantry corridor bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard south)
    (connected kitchen pantry east)
    (connected backyard kitchen north)
    (connected backyard corridor south)
    (connected pantry kitchen west)
    (connected corridor backyard north)
    (connected corridor bedroom south)
    (connected bedroom corridor north)
    (location coin bedroom)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (kitchen kitchen) (backyard backyard) (pantry pantry) (corridor corridor) (bedroom bedroom)
    (visited-kitchen)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)