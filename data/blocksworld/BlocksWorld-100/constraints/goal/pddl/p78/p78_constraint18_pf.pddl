(define (problem blocksworld-p78)
;; CONSTRAINT You must end the task by holding block 6.
  (:domain blocksworld)
  (:objects block1 block2 block3 block4 block5 block6 )
  (:init 
    (on-table block4)
    (on block5 block4)
    (on block6 block5)
    (on block1 block6)
    (on block2 block1)
    (on block3 block2)
    (clear block3)
    (arm-empty)
  )
  (:goal (and 
    (on-table block5)
    (on-table block1)
    (on-table block2)
    (on-table block4)
;; BEGIN EDIT
    (holding block6)
;; END
    (on-table block3)
  ))
)