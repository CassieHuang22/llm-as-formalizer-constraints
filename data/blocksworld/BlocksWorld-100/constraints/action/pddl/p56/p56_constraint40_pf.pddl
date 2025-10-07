(define (problem blocksworld-p56)
;; CONSTRAINT Even numbered blocks cannot be stacked on odd numbered blocks.
  (:domain blocksworld)
  (:objects block1 block2 block3 block4 block5 block6 )
  (:init 
    (on-table block3)
    (on block6 block3)
    (on block5 block6)
    (on block4 block5)
    (on block1 block4)
    (on block2 block1)
    (clear block2)
    (arm-empty)
;; BEGIN ADD
    (odd block1) (even block2) (odd block3) (even block4) (odd block5) (even block6)
;; END ADD
  )
  (:goal (and 
    (on-table block1)
    (on-table block2)
    (on block6 block2)
    (on-table block4)
    (on block3 block4)
    (on-table block5)
  ))
)