(define (problem blocksworld-p15)
;; CONSTRAINT Only 5 block pick ups are allowed in the entire task.
  (:domain blocksworld)
;; BEGIN EDIT
  (:objects block1 block2 block3 block4 block5 block6 block7 block8 - block
            t1 t2 t3 t4 t5 - token)
;; END EDIT
  (:init 
    (on-table block2)
    (on block6 block2)
    (on block4 block6)
    (clear block4)
    (on-table block3)
    (clear block3)
    (on-table block1)
    (on block5 block1)
    (on block7 block5)
    (on block8 block7)
    (clear block8)
    (arm-empty)
;; BEGIN ADD
    (unused t1) (unused t2) (unused t3) (unused t4) (unused t5)
;; END ADD
  )
  (:goal (and 
    (on-table block5)
    (on block6 block5)
    (on-table block4)
    (on-table block1)
    (on-table block3)
    (on-table block7)
    (on-table block2)
    (on-table block8)
  ))
)