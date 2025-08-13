(define (problem blocksworld-p58)
;; CONSTRAINT There are 2 robot hands, hand1 and hand2, so you can move two blocks at a time.
  (:domain blocksworld)
  (:objects 
    block1 block2 block3 block4 block5 block6 block7 block8 block9 block10 - block
;; BEGIN ADD
    hand1 hand2 - hand)
;; END ADD
  (:init 
    (on-table block2)
    (clear block2)
    (on-table block6)
    (clear block6)
    (on-table block9)
    (clear block9)
    (on-table block7)
    (clear block7)
    (on-table block5)
    (clear block5)
    (on-table block1)
    (clear block1)
    (on-table block10)
    (clear block10)
    (on-table block8)
    (clear block8)
    (on-table block3)
    (clear block3)
    (on-table block4)
    (clear block4)
;; BEGIN EDIT
    (hand-empty hand1)
    (hand-empty hand2)
;; END EDIT
  )
  (:goal (and 
    (on-table block8)
    (on block7 block8)
    (on-table block9)
    (on block10 block9)
    (on block3 block10)
    (on block5 block3)
    (on block2 block5)
    (on-table block4)
    (on-table block6)
    (on-table block1)
  ))
)