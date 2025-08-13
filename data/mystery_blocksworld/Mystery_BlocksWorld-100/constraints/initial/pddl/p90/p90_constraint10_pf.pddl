(define (problem mystery_blocksworld-p90)
;; CONSTRAINT You start with the objects in 2 clusters. The objects in one cluster are every third letter and the other cluster is the remaining objects. The objects are clusters in alphabetical order, with the first object in predicate2.
  (:domain mystery_blocksworld)
  (:objects a b c d e f )
  (:init 
;; BEGIN EDIT
    (predicate2 c)
    (predicate5 f c)
    (predicate1 f)
    (predicate2 a)
    (predicate5 b a)
    (predicate5 d b)
    (predicate5 e d)
    (predicate1 e)
;; END EDIT
    (predicate3)
  )
  (:goal (and 
    (predicate2 c)
    (predicate5 b c)
    (predicate5 a b)
    (predicate2 d)
    (predicate2 f)
    (predicate5 e f)
  ))
)