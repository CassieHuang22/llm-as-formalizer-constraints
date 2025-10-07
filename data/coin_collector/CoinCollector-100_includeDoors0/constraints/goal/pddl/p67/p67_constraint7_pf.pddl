(define (problem coin_collector_numLocations5_numDistractorItems0_seed21)
;; CONSTRAINT You must take the salt shaker to end the task.
  (:domain coin-collector)
  (:objects
    kitchen corridor pantry backyard bedroom - room
    north south east west - direction
;; BEGIN EDIT
    coin salt_shaker - item
;; END EDIT
  )
  (:init
    (at kitchen)
    (connected kitchen corridor north)
    (connected kitchen pantry south)
    (connected corridor kitchen south)
    (connected corridor backyard north)
    (connected corridor bedroom west)
    (connected pantry kitchen north)
    (connected backyard corridor south)
    (connected bedroom corridor east)
    (location coin kitchen)
    (is-reverse north south)
    (is-reverse south north)
    (is-reverse east west)
    (is-reverse west east)
  )
  (:goal 
;; BEGIN EDIT
    (taken salt_shaker)
;; END EDIT
  )
)