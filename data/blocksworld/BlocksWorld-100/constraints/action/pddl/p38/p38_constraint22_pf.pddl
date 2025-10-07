(define (problem blocksworld-p38)
;; CONSTRAINT If you move block1, you must move block2 immediately after. If you move block2 you must move block3 immediately after.
  (:domain blocksworld)
  (:objects block1 block2 block3 block4 )
  (:init 
    (on-table block1)
    (clear block1)
    (on-table block4)
    (clear block4)
    (on-table block3)
    (clear block3)
    (on-table block2)
    (clear block2)
    (arm-empty)
;; BEGIN ADD
    (first-block-1 block1)
    (second-block-1 block2)
    (first-block-2 block2)
    (second-block-2 block3)
;; END ADD
  )
  (:goal (and 
    (on-table block3)
    (on block2 block3)
    (on-table block1)
    (on block4 block1)
  ))
)