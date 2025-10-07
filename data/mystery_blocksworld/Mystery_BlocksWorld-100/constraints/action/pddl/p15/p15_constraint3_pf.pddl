(define (problem mystery_blocksworld-p15)
;; CONSTRAINT Only 5 uses of action1 are allowed in the entire task.
  (:domain mystery_blocksworld)
;; BEGIN EDIT
  (:objects object1 object2 object3 object4 object5 object6 object7 object8 - object
            t1 t2 t3 t4 t5 - token)
;; END EDIT
  (:init 
    (predicate2 object2)
    (predicate5 object6 object2)
    (predicate5 object4 object6)
    (predicate1 object4)
    (predicate2 object3)
    (predicate1 object3)
    (predicate2 object1)
    (predicate5 object5 object1)
    (predicate5 object7 object5)
    (predicate5 object8 object7)
    (predicate1 object8)
    (predicate3)
;; BEGIN ADD
    (unused t1) (unused t2) (unused t3) (unused t4) (unused t5)
;; END ADD
  )
  (:goal (and 
    (predicate2 object5)
    (predicate5 object6 object5)
    (predicate2 object4)
    (predicate2 object1)
    (predicate2 object3)
    (predicate2 object7)
    (predicate2 object2)
    (predicate2 object8)
  ))
)