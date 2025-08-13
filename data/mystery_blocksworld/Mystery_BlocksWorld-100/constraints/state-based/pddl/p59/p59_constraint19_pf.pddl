(define (problem mystery_blocksworld-p59)
;; CONSTRAINT You can now perform sets of actions on 3 objects at a time using 3 new objects, object-a, object-b and object-c
  (:domain mystery_blocksworld)
  (:objects 
      object1 object2 object3 object4 object5 object6 object7 object8 object9 object10 object11 object12 - object
;; BEGIN ADD
      object-a object-b object-c - new_object
;; END ADD
      )
  (:init 
    (predicate2 object2)
    (predicate5 object3 object2)
    (predicate5 object12 object3)
    (predicate5 object4 object12)
    (predicate1 object4)
    (predicate2 object6)
    (predicate1 object6)
    (predicate2 object9)
    (predicate1 object9)
    (predicate2 object7)
    (predicate1 object7)
    (predicate2 object5)
    (predicate1 object5)
    (predicate2 object11)
    (predicate1 object11)
    (predicate2 object10)
    (predicate5 object1 object10)
    (predicate1 object1)
    (predicate2 object8)
    (predicate1 object8)
;; BEGIN EDIT
    (predicate3 object-a) (predicate3 object-b) (predicate3 object-c)
;; END EDIT
  )
  (:goal (and 
    (predicate2 object9)
    (predicate2 object5)
    (predicate2 object8)
    (predicate2 object3)
    (predicate2 object10)
    (predicate2 object11)
    (predicate2 object6)
    (predicate2 object12)
    (predicate2 object4)
    (predicate2 object2)
    (predicate2 object7)
    (predicate2 object1)
  ))
)