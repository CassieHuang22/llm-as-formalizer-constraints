(define (problem blocksworld-p01)
;; CONSTRAINT The higher number the block, the heavier it is. Once, you start moving blocks, do not stack heavier blocks on lighter blocks.
  (:domain blocksworld)
  (:objects block1 block2 block3 block4 )
  (:init 
    (on-table block3)
    (clear block3)
    (on-table block4)
    (clear block4)
    (on-table block1)
    (clear block1)
    (on-table block2)
    (clear block2)
    (arm-empty)
;; BEGIN ADD
    (heavier block2 block1)
    (heavier block3 block2) (heavier block3 block1)
    (heavier block4 block3) (heavier block4 block2) (heavier block4 block1)
;; END ADD
  )
  (:goal (and 
    (on-table block4)
    (on-table block2)
    (on-table block1)
    (on-table block3)
  ))
)