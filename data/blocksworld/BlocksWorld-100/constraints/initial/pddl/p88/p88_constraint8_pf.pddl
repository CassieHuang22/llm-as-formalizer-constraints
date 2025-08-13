(define (problem blocksworld-p88)
;; CONSTRAINT You start by holding the blue block.
  (:domain blocksworld)
  (:objects red blue green yellow )
  (:init 
    (on-table red)
;; BEGIN EDIT
    (clear red)
    (holding blue)
;; END EDIT
    (on-table green)
    (on yellow green)
    (clear yellow)
;; BEGIN DELETE
;; END DELETE
  )
  (:goal (and 
    (on-table red)
    (on green red)
    (on yellow green)
    (on blue yellow)
  ))
)