(define (problem coin_collector_numLocations3_numDistractorItems0_seed68)
;; CONSTRAINT After taking the coin, you must be in the room furthest south and furthest east to end the task.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry north)
    (connected kitchen corridor west)
    (connected pantry kitchen south)
    (connected corridor kitchen east)
    (location coin corridor)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
;; BEGIN EDIT
    (and
      (taken coin)
      (at kitchen)
    )
;; END EDIT
  )
)