(define (problem coin_collector_numLocations3_numDistractorItems0_seed26)
;; CONSTRAINT You must visit the corridor before the pantry.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry east)
    (connected kitchen corridor west)
    (connected pantry kitchen west)
    (connected corridor kitchen east)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (must-visit-before-next corridor)
    (next-room pantry)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)