(define (problem coin_collector_numLocations5_numDistractorItems0_seed43)
;; CONSTRAINT There is another room, the closet, west of the pantry.
  (:domain coin-collector)
  (:objects
;; BEGIN EDIT
    kitchen backyard pantry corridor bedroom closet - room
;; END EDIT
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen backyard north)
    (connected kitchen pantry west)
    (connected backyard kitchen south)
    (connected backyard corridor west)
    (connected pantry kitchen east)
    (connected corridor backyard east)
    (connected corridor bedroom west)
    (connected bedroom corridor east)
;; BEGIN ADD
    (connected pantry closet west)
    (connected closet pantry east)
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