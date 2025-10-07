(define (problem coin_collector_numLocations3_numDistractorItems0_seed95)
;; CONSTRAINT After taking the coin, you must be in the corridor to end the task.
  (:domain coin-collector)
  (:objects
    kitchen pantry corridor - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen pantry south)
    (connected kitchen corridor east)
    (connected pantry kitchen north)
    (connected corridor kitchen west)
    (location coin kitchen)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
;; BEGIN EDIT
    (and
      (taken coin)
      (at corridor)
    )
;; END EDIT
  )
)