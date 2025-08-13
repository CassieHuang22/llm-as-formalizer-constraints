(define (problem mystery_blocksworld-p87)
;; CONSTRAINT You start with a in predicate4.
  (:domain mystery_blocksworld)
  (:objects a b c )
  (:init 
    (predicate2 b)
    (predicate1 b)
;; BEGIN EDIT
    (predicate4 a)
;; END EDIT
    (predicate2 c)
    (predicate1 c)
;; BEGIN DELETE
;; END DELETE
  )
  (:goal (and 
    (predicate2 c)
    (predicate5 b c)
    (predicate5 a b)
  ))
)