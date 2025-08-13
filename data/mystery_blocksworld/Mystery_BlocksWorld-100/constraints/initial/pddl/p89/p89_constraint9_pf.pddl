(define (problem mystery_blocksworld-p89)
;; CONSTRAINT You start with the objects in 2 clusters. One tower constains objects with every second letter, the remaining objects are in the second cluster. The objects are clustered in alphabetical order, with the first letter in predicate2.
  (:domain mystery_blocksworld)
  (:objects a b c d e )
  (:init 
;; BEGIN EDIT
    (predicate2 a)
    (predicate5 c a)
    (predicate5 e c)
    (predicate1 e)
    (predicate2 b)
    (predicate5 d b)
    (predicate1 d)
;; END EDIT
    (predicate3)
  )
  (:goal (and 
    (predicate2 e)
    (predicate5 d e)
    (predicate5 c d)
    (predicate5 b c)
    (predicate5 a b)
  ))
)