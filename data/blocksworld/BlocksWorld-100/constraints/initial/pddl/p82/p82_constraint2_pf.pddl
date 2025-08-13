(define (problem blocksworld-p82)
;; CONSTRAINT You start with all blocks on the table.
  (:domain blocksworld)
  (:objects block1 block2 block3 block4 block5 block6 block7 block8 block9 block10 block11 )
  (:init 
;; BEGIN EDIT
    (on-table block1) (on-table block2) (on-table block3) (on-table block4)
    (on-table block5) (on-table block6) (on-table block7) (on-table block8)
    (on-table block9) (on-table block10) (on-table block11)
    (clear block1) (clear block2) (clear block3) (clear block4) (clear block5) (clear block6) (clear block7) (clear block8) (clear block9) (clear block10) (clear block11)
;; END EDIT
    (arm-empty)
  )
  (:goal (and 
    (on-table block7)
    (on block4 block7)
    (on block11 block4)
    (on block2 block11)
    (on block9 block2)
    (on block5 block9)
    (on block8 block5)
    (on block10 block8)
    (on block1 block10)
    (on block3 block1)
    (on block6 block3)
  ))
)