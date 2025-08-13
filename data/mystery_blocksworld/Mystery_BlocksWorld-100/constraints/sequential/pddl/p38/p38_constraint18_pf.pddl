(define (problem mystery_blocksworld-p38)
;; CONSTRAINT If you perform a set of objects on object1, you must perform a set of actions on object2 immediately after. If you perform a set of actions on object2 you must perform a set of actions on object3 immediately after.
  (:domain mystery_blocksworld)
  (:objects object1 object2 object3 object4 )
  (:init 
    (predicate2 object1)
    (predicate1 object1)
    (predicate2 object4)
    (predicate1 object4)
    (predicate2 object3)
    (predicate1 object3)
    (predicate2 object2)
    (predicate1 object2)
    (predicate3)
;; BEGIN ADD
    (first-object-1 object1)
    (second-object-1 object2)
    (first-object-2 object2)
    (second-object-2 object3)
;; END ADD
  )
  (:goal (and 
    (predicate2 object3)
    (predicate5 object2 object3)
    (predicate2 object1)
    (predicate5 object4 object1)
  ))
)