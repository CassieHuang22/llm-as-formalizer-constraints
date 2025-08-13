(define (problem blocksworld-p87)
;; CONSTRAINT You start with holding block A.
  (:domain blocksworld)
  (:objects a b c )
  (:init 
    (on-table b)
    (clear b)
;; BEGIN EDIT
    (holding a)
;; END EDIT
    (on-table c)
    (clear c)
;; BEGIN DELETE
;; END DELETE
  )
  (:goal (and 
    (on-table c)
    (on b c)
    (on a b)
  ))
)