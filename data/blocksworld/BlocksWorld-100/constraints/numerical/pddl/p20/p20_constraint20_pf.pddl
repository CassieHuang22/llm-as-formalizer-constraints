(define (problem blocksworld-p20)
;; CONSTRAINT Once you start moving blocks, the sum of the block numbers in each stack should not exceed 5.
  (:domain blocksworld)
  (:objects block1 block2 block3 )
  (:init 
    (on-table block3)
    (clear block3)
    (on-table block2)
    (on block1 block2)
    (clear block1)
    (arm-empty)
;; BEGIN ADD
    (val-1 block1) (cap-4 block1)
    (val-2 block2) (cap-3 block2)
    (val-3 block3) (cap-2 block3)
;; END ADD
  )
  (:goal (and 
    (on-table block3)
    (on block2 block3)
    (on block1 block2)
  ))
)