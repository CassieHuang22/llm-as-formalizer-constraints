(define (problem blocksworld-p60)
;; CONSTRAINT There are 4 robot hands, hand1, hand2, hand3 and hand4, so you can move four blocks at a time.
  (:domain blocksworld)
  (:objects 
      block1 block2 block3 block4 block5 block6 block7 block8 block9 - block
;; BEGIN ADD
      hand1 hand2 hand3 hand4 - hand
;; END ADD
      )
  (:init 
    (on-table block2)
    (clear block2)
    (on-table block9)
    (clear block9)
    (on-table block4)
    (clear block4)
    (on-table block1)
    (clear block1)
    (on-table block7)
    (clear block7)
    (on-table block8)
    (on block5 block8)
    (clear block5)
    (on-table block3)
    (on block6 block3)
    (clear block6)
;; BEGIN EDIT
    (arm-empty hand1) (arm-empty hand2) (arm-empty hand3) (arm-empty hand4)
;; END EDIT
  )
  (:goal (and 
    (on-table block2)
    (on-table block3)
    (on-table block5)
    (on-table block1)
    (on-table block6)
    (on block7 block6)
    (on-table block9)
    (on block4 block9)
    (on-table block8)
  ))
)