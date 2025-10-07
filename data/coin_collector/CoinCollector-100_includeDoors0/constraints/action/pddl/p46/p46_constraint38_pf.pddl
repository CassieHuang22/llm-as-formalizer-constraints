(define (problem coin_collector_numLocations5_numDistractorItems0_seed57)
;; CONSTRAINT You can only move north or move east
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry backyard bedroom - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor north)
    (connected kitchen pantry south)
    (connected kitchen backyard west)
    (connected corridor kitchen south)
    (connected corridor bedroom east)
    (connected pantry kitchen north)
    (connected backyard kitchen east)
    (connected bedroom corridor west)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
;; BEGIN ADD
    (allowed-direction north)
    (allowed-direction east)
;; END ADD
  )
  (:goal 
    (taken coin)
  )
)