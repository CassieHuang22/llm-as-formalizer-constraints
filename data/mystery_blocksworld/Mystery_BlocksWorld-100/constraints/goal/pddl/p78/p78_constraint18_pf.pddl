(define (problem mystery_blocksworld-p78)
;; CONSTRAINT You must complete the task with object6 in predicate4.
  (:domain mystery_blocksworld)
  (:objects object1 object2 object3 object4 object5 object6 )
  (:init 
    (predicate2 object4)
    (predicate5 object5 object4)
    (predicate5 object6 object5)
    (predicate5 object1 object6)
    (predicate5 object2 object1)
    (predicate5 object3 object2)
    (predicate1 object3)
    (predicate3)
  )
  (:goal (and 
    (predicate2 object5)
    (predicate2 object1)
    (predicate2 object2)
    (predicate2 object4)
;; BEGIN EDIT
    (predicate4 object6)
;; END
    (predicate2 object3)
  ))
)