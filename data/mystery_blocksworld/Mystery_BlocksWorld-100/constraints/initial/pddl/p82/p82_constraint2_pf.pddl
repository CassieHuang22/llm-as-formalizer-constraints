(define (problem mystery_blocksworld-p82)
;; CONSTRAINT You start with all objects in predicate2.
  (:domain mystery_blocksworld)
  (:objects object1 object2 object3 object4 object5 object6 object7 object8 object9 object10 object11 )
  (:init 
;; BEGIN EDIT
    (predicate2 object1) (predicate2 object2) (predicate2 object3) (predicate2 object4)
    (predicate2 object5) (predicate2 object6) (predicate2 object7) (predicate2 object8)
    (predicate2 object9) (predicate2 object10) (predicate2 object11)
    (predicate1 object1) (predicate1 object2) (predicate1 object3) (predicate1 object4) (predicate1 object5) (predicate1 object6) (predicate1 object7) (predicate1 object8) (predicate1 object9) (predicate1 object10) (predicate1 object11)
;; END EDIT
    (predicate3)
  )
  (:goal (and 
    (predicate2 object7)
    (predicate5 object4 object7)
    (predicate5 object11 object4)
    (predicate5 object2 object11)
    (predicate5 object9 object2)
    (predicate5 object5 object9)
    (predicate5 object8 object5)
    (predicate5 object10 object8)
    (predicate5 object1 object10)
    (predicate5 object3 object1)
    (predicate5 object6 object3)
  ))
)