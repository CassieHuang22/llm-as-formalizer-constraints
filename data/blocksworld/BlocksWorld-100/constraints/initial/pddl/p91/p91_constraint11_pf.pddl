(define (problem blocksworld-p91)
;; CONSTRAINT You start with the blocks in 2 stacks. The blocks in one tower are every fourth letter and the other tower is the remaining blocks. The towers are stacked in alphabetical order with the first letter on the table.
  (:domain blocksworld)
  (:objects a b c d e f g )
  (:init 
;; BEGIN EDIT
    (on-table d)
    (clear d)
    (on-table a)
    (on b a)
    (on c b)
    (on e c)
    (on f e)
    (on g f)
    (clear g)
;; END EDIT
    (arm-empty)
  )
  (:goal (and 
    (on-table a)
    (on b a)
    (on c b)
    (on-table d)
    (on e d)
    (on-table f)
    (on g f)
  ))
)