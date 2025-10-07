(define (domain mystery_blocksworld)
;; CONSTRAINT Once you start performing actions on the objects, you must have no more than 1 cluster at any time.
  (:requirements :strips)
  (:predicates
        (predicate5 ?x ?y)
        (predicate2 ?x)
        (predicate1 ?x)
        (predicate4 ?x)
        (predicate3)
;; BEGIN ADD
        (cluster-occupied)
;; END ADD
        )

  (:action action1
     :parameters (?b)
     :precondition (and (predicate2 ?b) (predicate1 ?b) (predicate3)
;; BEGIN ADD
                        (cluster-occupied)
;; END ADD
     )
     :effect (and (predicate4 ?b)
                  (not (predicate2 ?b))
                  (not (predicate1 ?b))
                  (not (predicate3))
;; BEGIN ADD
                  (not (cluster-occupied))
;; END ADD
     )
  )

  (:action action4
     :parameters (?top ?below)
     :precondition (and (predicate5 ?top ?below) (predicate1 ?top) (predicate3))
     :effect (and (predicate4 ?top)
                  (predicate1 ?below)
                  (not (predicate5 ?top ?below))
                  (not (predicate1 ?top))
                  (not (predicate3)))
  )

  (:action action2
     :parameters (?b)
;; BEGIN EDIT
     :precondition (and (predicate4 ?b)
                        (not (cluster-occupied)))   
;; END EDIT
     :effect (and (predicate2 ?b) (predicate1 ?b)
                  (predicate3) (not (predicate4 ?b))
;; BEGIN ADD
                  (cluster-occupied)
;; END ADD
     )
  )

  (:action action3
     :parameters (?top ?below)
     :precondition (and (predicate4 ?top) (predicate1 ?below))
     :effect (and (predicate5 ?top ?below)
                  (predicate1 ?top)
                  (predicate3)
                  (not (predicate4 ?top))
                  (not (predicate1 ?below)))
  )
)