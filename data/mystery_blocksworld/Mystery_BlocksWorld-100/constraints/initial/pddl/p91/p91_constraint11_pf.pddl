(define (problem mystery_blocksworld-p91)
;; CONSTRAINT You start with the objects in 2 clusters. The objects in one cluster are every fourth letter and the other cluster is the remaining objects. The objects are clustered in alphabetical order with the first letter in predicate2.
  (:domain mystery_blocksworld)
  (:objects a b c d e f g )
  (:init 
;; BEGIN EDIT
    (predicate2 d)
    (predicate1 d)
    (predicate2 a)
    (predicate5 b a)
    (predicate5 c b)
    (predicate5 e c)
    (predicate5 f e)
    (predicate5 g f)
    (predicate1 g)
;; END EDIT
    (predicate3)
  )
  (:goal (and 
    (predicate2 a)
    (predicate5 b a)
    (predicate5 c b)
    (predicate2 d)
    (predicate5 e d)
    (predicate2 f)
    (predicate5 g f)
  ))
)