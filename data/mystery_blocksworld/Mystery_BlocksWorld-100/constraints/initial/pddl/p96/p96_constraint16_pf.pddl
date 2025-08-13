(define (problem mystery_blocksworld-p96)
;; CONSTRAINT You start with f in predicate4.
  (:domain mystery_blocksworld)
  (:objects a b c d e f g h i j k )
  (:init 
    (predicate2 a)
    (predicate5 b a)
    (predicate5 c b)
    (predicate1 c)
    (predicate2 d)
    (predicate5 e d)
    (predicate1 e)
;; BEGIN EDIT
    (predicate4 f)
;; END EDIT
    (predicate2 g)
    (predicate5 h g)
    (predicate5 i h)
    (predicate5 j i)
    (predicate5 k j)
    (predicate1 k)
;; BEGIN DELETE
;; END DELETE
  )
  (:goal (and 
    (predicate2 a)
    (predicate5 b a)
    (predicate5 c b)
    (predicate2 d)
    (predicate5 e d)
    (predicate2 f)
    (predicate5 g f)
    (predicate5 h g)
    (predicate5 i h)
    (predicate5 j i)
    (predicate5 k j)
  ))
)