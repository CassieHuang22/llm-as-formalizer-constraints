(define (problem mystery_blocksworld-p97)
  (:domain mystery_blocksworld)
  (:objects object1 object2 )
  (:init 
    (predicate2 object1)
    (predicate5 object2 object1)
    (predicate1 object2)
    (predicate3)
  )
  (:goal (and 
    (predicate2 object2)
    (predicate2 object1)
  ))
)