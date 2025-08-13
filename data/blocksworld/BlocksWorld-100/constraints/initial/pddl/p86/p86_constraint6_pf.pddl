(define (problem blocksworld-p86)
;; CONSTRAINT You start by holding block2.
  (:domain blocksworld)
  (:objects block1 block2 )
  (:init 
    (on-table block1)
    (clear block1)
;; BEGIN EDIT
    (holding block2)
;; END EDIT
  )
  (:goal (and 
    (on-table block2)
    (on-table block1)
  ))
)