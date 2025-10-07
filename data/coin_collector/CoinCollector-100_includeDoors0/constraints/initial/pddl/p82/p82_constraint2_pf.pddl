(define (problem coin_collector_numLocations3_numDistractorItems0_seed12)
;; CONSTRAINT You start in the corridor.
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry - room
    north south east west - direction
    coin - item
  )
  (:init
;; BEGIN EDIT
    (at corridor)
;; END EDIT
    (connected kitchen corridor north)
    (connected kitchen pantry south)
    (connected corridor kitchen south)
    (connected pantry kitchen north)
    (location coin kitchen)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)