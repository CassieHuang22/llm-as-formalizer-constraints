(define (problem mystery_blocksworld-p20)
;; CONSTRAINT Once you start performing actions on the objects, the sum of the object numbers in each cluster should not exceed 5.
  (:domain mystery_blocksworld)
  (:objects object1 object2 object3 )
  (:init 
    (predicate2 object3)
    (predicate1 object3)
    (predicate2 object2)
    (predicate5 object1 object2)
    (predicate1 object1)
    (predicate3)
;; BEGIN ADD
    (val-1 object1) (cap-4 object1)
    (val-2 object2) (cap-3 object2)
    (val-3 object3) (cap-2 object3)
;; END ADD
  )
  (:goal (and 
    (predicate2 object3)
    (predicate5 object2 object3)
    (predicate5 object1 object2)
  ))
)