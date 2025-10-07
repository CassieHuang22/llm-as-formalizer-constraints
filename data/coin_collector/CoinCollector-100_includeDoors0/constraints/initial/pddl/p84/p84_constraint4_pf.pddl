(define (problem coin_collector_numLocations3_numDistractorItems0_seed28)
;; CONSTRAINT There is a another room, the office, west of the kitchen.
  (:domain coin-collector)
  (:objects
;; BEGIN EDIT
    kitchen pantry corridor office - room
;; END EDIT
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen corridor east)
    (connected pantry kitchen south)
    (connected corridor kitchen west)
;; BEGIN ADD
    (connected kitchen office west)
    (connected office kitchen east)
;; END ADD
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
    (taken coin)
  )
)