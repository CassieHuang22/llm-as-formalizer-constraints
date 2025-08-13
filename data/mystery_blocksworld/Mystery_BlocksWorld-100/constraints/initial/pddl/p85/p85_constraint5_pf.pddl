(define (problem mystery_blocksworld-p85)
;; CONSTRAINT You start with object6 in predicate4.
  (:domain mystery_blocksworld)
  (:objects object1 object2 object3 object4 object5 object6 object7 object8 object9 )
  (:init 
    (predicate2 object5)
    (predicate1 object5)
    (predicate2 object8)
    (predicate5 object2 object8)
    (predicate1 object2)
    (predicate2 object4)
    (predicate1 object4)
    (predicate2 object7)
    (predicate1 object7)
    (predicate2 object3)
    (predicate5 object1 object3)
;; BEGIN EDIT
    (predicate1 object1)
    (predicate4 object6)
;; END EDIT
    (predicate2 object9)
    (predicate1 object9)
;; BEGIN DELETE
;; END DELETE
  )
  (:goal (and 
    (predicate2 object6)
    (predicate5 object1 object6)
    (predicate5 object4 object1)
    (predicate5 object9 object4)
    (predicate2 object2)
    (predicate5 object5 object2)
    (predicate5 object7 object5)
    (predicate2 object3)
    (predicate5 object8 object3)
  ))
)