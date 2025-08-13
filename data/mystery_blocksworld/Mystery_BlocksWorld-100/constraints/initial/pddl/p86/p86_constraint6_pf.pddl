(define (problem mystery_blocksworld-p86)
;; CONSTRAINT You start with object2 in predicate4.
  (:domain mystery_blocksworld)
  (:objects object1 object2 )
  (:init 
    (predicate2 object1)
    (predicate1 object1)
;; BEGIN EDIT
    (predicate4 object2)
;; END EDIT
  )
  (:goal (and 
    (predicate2 object2)
    (predicate2 object1)
  ))
)