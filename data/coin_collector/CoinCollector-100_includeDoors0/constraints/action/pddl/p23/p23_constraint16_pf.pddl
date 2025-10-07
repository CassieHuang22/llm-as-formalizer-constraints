(define (problem coin_collector_numLocations3_numDistractorItems0_seed30)
;; You can't pick up any coin if you haven't been to the corridor.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen corridor west)
    (connected pantry kitchen north)
    (connected corridor kitchen east)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (must-visit-room corridor)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)