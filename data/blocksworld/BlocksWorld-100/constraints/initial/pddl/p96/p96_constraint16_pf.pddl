(define (problem blocksworld-p96)
;; CONSTRAINT You start by holding block F.
  (:domain blocksworld)
  (:objects a b c d e f g h i j k )
  (:init 
    (on-table a)
    (on b a)
    (on c b)
    (clear c)
    (on-table d)
    (on e d)
    (clear e)
;; BEGIN EDIT
    (holding f)
;; END EDIT
    (on-table g)
    (on h g)
    (on i h)
    (on j i)
    (on k j)
    (clear k)
;; BEGIN DELETE
;; END DELETE
  )
  (:goal (and 
    (on-table a)
    (on b a)
    (on c b)
    (on-table d)
    (on e d)
    (on-table f)
    (on g f)
    (on h g)
    (on i h)
    (on j i)
    (on k j)
  ))
)