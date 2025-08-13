(define (problem mystery_blocksworld-p88)
;; CONSTRAINT You start with blue in predicate4.
  (:domain mystery_blocksworld)
  (:objects red blue green yellow )
  (:init 
    (predicate2 red)
;; BEGIN EDIT
    (predicate1 red)
    (predicate4 blue)
;; END EDIT
    (predicate2 green)
    (predicate5 yellow green)
    (predicate1 yellow)
;; BEGIN DELETE
;; END DELETE
  )
  (:goal (and 
    (predicate2 red)
    (predicate5 green red)
    (predicate5 yellow green)
    (predicate5 blue yellow)
  ))
)