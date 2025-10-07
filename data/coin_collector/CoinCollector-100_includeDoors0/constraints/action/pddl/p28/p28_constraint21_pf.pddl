(define (problem coin_collector_numLocations5_numDistractorItems0_seed47)
;; CONSTRAINT If you visit the corridor, you must visit the bedroom within the next two moves.
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
    (connected kitchen corridor west)
    (connected backyard kitchen north)
    (connected pantry kitchen west)
    (connected corridor kitchen east)
    (connected corridor bedroom west)
    (connected bedroom corridor east)
    (location coin backyard)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (first-room corridor)
    (second-room bedroom)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)