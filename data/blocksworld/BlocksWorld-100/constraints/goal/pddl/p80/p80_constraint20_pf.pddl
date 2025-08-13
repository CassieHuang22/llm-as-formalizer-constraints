(define (problem blocksworld-p80)
;; CONSTRAINT You must end the task with the blocks in 4 stacks. The blocks in one tower are multiple of 3 that are odd and  another tower constraints blocks that are multiples of 3 and are even. The third tower does not contain multiples of 3 but are odd, the final tower contains blocks that are not multiples of 3 but are even. The towers are stacked in order with the lowest number block on the table and the highest block on top.
  (:domain blocksworld)
  (:objects block1 block2 block3 block4 block5 block6 block7 )
  (:init 
    (on-table block5)
    (on block4 block5)
    (on block1 block4)
    (on block2 block1)
    (clear block2)
    (on-table block6)
    (on block7 block6)
    (on block3 block7)
    (clear block3)
    (arm-empty)
  )
  (:goal (and 
;; BEGIN EDIT
    (on-table block3)
    (on-table block6)
    (on-table block1)
    (on block5 block1)
    (on block7 block5)
    (on-table block2)
    (on block4 block2)
;; END EDIT
  ))
)