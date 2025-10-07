(define (problem coin_collector_numLocations3_numDistractorItems0_seed3)
;; CONSTRAINT Without taking the coin, you must be in the kitchen to end the task.
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry - room
    north south east west - direction
    coin - item
  )
  (:init
    (at kitchen)
    (connected kitchen corridor north)
    (connected kitchen pantry east)
    (connected corridor kitchen south)
    (connected pantry kitchen west)
    (location coin pantry)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
;; BEGIN EDIT
    (and
      (not (taken coin))
      (at kitchen)
    )
;; END EDIT
  )
)