(define (problem mystery_blocksworld-p01)
;; CONSTRAINT The higher number the object, the heavier it is. Once, you start performing actions on the objects, do not action3 heavier objects with lighter objects
  (:domain mystery_blocksworld)
  (:objects object1 object2 object3 object4 )
  (:init 
    (predicate2 object3)
    (predicate1 object3)
    (predicate2 object4)
    (predicate1 object4)
    (predicate2 object1)
    (predicate1 object1)
    (predicate2 object2)
    (predicate1 object2)
    (predicate3)
;; BEGIN ADD
    (heavier object2 object1)
    (heavier object3 object2) (heavier object3 object1)
    (heavier object4 object3) (heavier object4 object2) (heavier object4 object1)
;; END ADD
  )
  (:goal (and 
    (predicate2 object4)
    (predicate2 object2)
    (predicate2 object1)
    (predicate2 object3)
  ))
)