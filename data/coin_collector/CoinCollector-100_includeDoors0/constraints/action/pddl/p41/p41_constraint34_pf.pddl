(define (problem coin_collector_numLocations3_numDistractorItems0_seed90)
  (:domain coin-collector)
;; CONSTRAINT Do not move into the corridor.
  (:objects
    kitchen pantry corridor - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen corridor east)
    (connected pantry kitchen south)
    (connected corridor kitchen west)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (not-allowed-room corridor)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)