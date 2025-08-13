(define (problem mystery_blocksworld-p80)
;; CONSTRAINT You must end the task with the objects in 4 clusters. The objects in one cluster are multiple of 3 that are odd and  another cluster constraints objects that are multiples of 3 and are even. The third cluster does not contain multiples of 3 but are odd, the final cluster contains objects that are not multiples of 3 but are even. The objects are clustered in order with the lowest number object in predicate2 and the highest object in predicate1.
  (:domain mystery_blocksworld)
  (:objects object1 object2 object3 object4 object5 object6 object7 )
  (:init 
    (predicate2 object5)
    (predicate5 object4 object5)
    (predicate5 object1 object4)
    (predicate5 object2 object1)
    (predicate1 object2)
    (predicate2 object6)
    (predicate5 object7 object6)
    (predicate5 object3 object7)
    (predicate1 object3)
    (predicate3)
  )
  (:goal (and 
;; BEGIN EDIT
    (predicate2 object3)
    (predicate2 object6)
    (predicate2 object1)
    (predicate5 object5 object1)
    (predicate5 object7 object5)
    (predicate2 object2)
    (predicate5 object4 object2)
;; END EDIT
  ))
)