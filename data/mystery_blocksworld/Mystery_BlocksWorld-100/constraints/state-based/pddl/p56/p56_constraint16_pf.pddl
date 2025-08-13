(define (problem mystery_blocksworld-p56)
;; CONSTRAINT Do not perform action3 with an even numbered object and an odd numbered object
  (:domain mystery_blocksworld)
  (:objects object1 object2 object3 object4 object5 object6 )
  (:init 
    (predicate2 object3)
    (predicate5 object6 object3)
    (predicate5 object5 object6)
    (predicate5 object4 object5)
    (predicate5 object1 object4)
    (predicate5 object2 object1)
    (predicate1 object2)
    (predicate3)
;; BEGIN ADD
    (odd object1) (even object2) (odd object3) (even object4) (odd object5) (even object6)
;; END ADD
  )
  (:goal (and 
    (predicate2 object1)
    (predicate2 object2)
    (predicate5 object6 object2)
    (predicate2 object4)
    (predicate5 object3 object4)
    (predicate2 object5)
  ))
)