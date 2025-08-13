(define (problem mystery_blocksworld-p60)
;; CONSTRAINT You can now perform sets of actions on 4 objects at a time using 4 new objects, object-a, object-b, object-c and object-d
  (:domain mystery_blocksworld)
  (:objects 
      object1 object2 object3 object4 object5 object6 object7 object8 object9 - object
;; BEGIN ADD
      object-a object-b object-c object-d - new_object
;; END ADD
      )
  (:init 
    (predicate2 object2)
    (predicate1 object2)
    (predicate2 object9)
    (predicate1 object9)
    (predicate2 object4)
    (predicate1 object4)
    (predicate2 object1)
    (predicate1 object1)
    (predicate2 object7)
    (predicate1 object7)
    (predicate2 object8)
    (predicate5 object5 object8)
    (predicate1 object5)
    (predicate2 object3)
    (predicate5 object6 object3)
    (predicate1 object6)
;; BEGIN EDIT
    (predicate3 object-a) (predicate3 object-b) (predicate3 object-c) (predicate3 object-d)
;; END EDIT
  )
  (:goal (and 
    (predicate2 object2)
    (predicate2 object3)
    (predicate2 object5)
    (predicate2 object1)
    (predicate2 object6)
    (predicate5 object7 object6)
    (predicate2 object9)
    (predicate5 object4 object9)
    (predicate2 object8)
  ))
)