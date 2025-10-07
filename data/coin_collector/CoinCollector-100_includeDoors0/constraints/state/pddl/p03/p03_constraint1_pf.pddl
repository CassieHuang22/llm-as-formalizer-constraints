(define (problem coin_collector_numLocations3_numDistractorItems0_seed14)
;; Each room has their own ID number (kitchen=1, pantry=2, corridor=3, backyard=4, bedroom=5, living room = 6, bathroom=7, laundry room=8, driveway=9, street=10, supermarket=11) the sum of all IDs for the rooms you visit, including the starting room, cannot exceed 3.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen corridor south)
    (connected pantry kitchen south)
    (connected corridor kitchen north)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (kitchen kitchen) (corridor corridor) (pantry pantry)
    (visited-kitchen)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)