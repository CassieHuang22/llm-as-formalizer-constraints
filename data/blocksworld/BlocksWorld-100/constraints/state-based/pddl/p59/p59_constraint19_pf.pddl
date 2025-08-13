(define (problem blocksworld-p59)
;; CONSTRAINT There are 3 robot hands, hand1, hand2 and hand3, so you can move three blocks at a time.
  (:domain blocksworld)
  (:objects 
      block1 block2 block3 block4 block5 block6 block7 block8 block9 block10 block11 block12 - block
;; BEGIN ADD
      hand1 hand2 hand3 - hand
;; END ADD
      )
  (:init 
    (on-table block2)
    (on block3 block2)
    (on block12 block3)
    (on block4 block12)
    (clear block4)
    (on-table block6)
    (clear block6)
    (on-table block9)
    (clear block9)
    (on-table block7)
    (clear block7)
    (on-table block5)
    (clear block5)
    (on-table block11)
    (clear block11)
    (on-table block10)
    (on block1 block10)
    (clear block1)
    (on-table block8)
    (clear block8)
;; BEGIN EDIT
    (hand-empty hand1) (hand-empty hand2) (hand-empty hand3)
;; END EDIT
  )
  (:goal (and 
    (on-table block9)
    (on-table block5)
    (on-table block8)
    (on-table block3)
    (on-table block10)
    (on-table block11)
    (on-table block6)
    (on-table block12)
    (on-table block4)
    (on-table block2)
    (on-table block7)
    (on-table block1)
  ))
)