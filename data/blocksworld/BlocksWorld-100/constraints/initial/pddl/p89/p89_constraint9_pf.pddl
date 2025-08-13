(define (problem blocksworld-p89)
;; CONSTRAINT You start with the blocks in 2 stacks. One tower constains blocks with every second letter, the remaining blocks are in the second tower. The towers are stacked in alphabetical order, with the first letter on the table.
  (:domain blocksworld)
  (:objects a b c d e )
  (:init 
;; BEGIN EDIT
    (on-table a)
    (on c a)
    (on e c)
    (clear e)
    (on-table b)
    (on d b)
    (clear d)
;; END EDIT
    (arm-empty)
  )
  (:goal (and 
    (on-table e)
    (on d e)
    (on c d)
    (on b c)
    (on a b)
  ))
)