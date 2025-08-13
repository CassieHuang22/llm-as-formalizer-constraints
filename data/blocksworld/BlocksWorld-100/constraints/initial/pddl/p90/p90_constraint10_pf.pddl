(define (problem blocksworld-p90)
;; CONSTRAINT You start with the blocks in 2 stacks. The blocks in one tower are every third letter and the other tower is the remaining blocks. The towers are stacked in alphabetical order, with the first block on the table.
  (:domain blocksworld)
  (:objects a b c d e f )
  (:init 
;; BEGIN EDIT
    (on-table c)
    (on f c)
    (clear f)
    (on-table a)
    (on b a)
    (on d b)
    (on e d)
    (clear e)
;; END EDIT
    (arm-empty)
  )
  (:goal (and 
    (on-table c)
    (on b c)
    (on a b)
    (on-table d)
    (on-table f)
    (on e f)
  ))
)