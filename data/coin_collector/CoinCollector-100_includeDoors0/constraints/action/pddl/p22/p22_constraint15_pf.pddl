(define (problem coin_collector_numLocations3_numDistractorItems0_seed38)
;; CONSTRAINT You must visit the pantry twice before going to the corridor.
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor north)
    (connected kitchen pantry east)
    (connected corridor kitchen south)
    (connected pantry kitchen west)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (next-room corridor)
    (must-visit-twice pantry)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)