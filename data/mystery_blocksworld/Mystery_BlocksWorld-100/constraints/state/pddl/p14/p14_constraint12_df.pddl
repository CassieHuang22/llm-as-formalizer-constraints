(define (domain mystery_blocksworld)
;; CONSTRAINT Once you start performing actions on the objects, you must have no more than 3 clusters at any time.
  (:requirements :strips :typing)
;; BEGIN EDIT
  (:types object cluster)  

  (:predicates
        (predicate5        ?x - object ?y - object)
        (predicate2  ?x - object)
        (predicate1     ?x - object)
        (predicate4   ?x - object)
        (predicate3)
;; BEGIN ADD
        (free ?s - cluster)                 
        (in-cluster ?b - object ?s - cluster)
;; END ADD
        )  
;; BEGIN EDIT                                      
  (:action action1
     :parameters (?b - object ?s - cluster)
     :precondition (and (predicate2 ?b) (predicate1 ?b) (predicate3)
                        (in-cluster ?b ?s))
     :effect (and (predicate4 ?b)
                  (not (predicate2 ?b))
                  (not (predicate3))
                  (not (in-cluster ?b ?s))
                  (free ?s))
  )
;; END EDIT

  (:action action4
     :parameters (?top - object ?below - object)
     :precondition (and (predicate5 ?top ?below) (predicate1 ?top) (predicate3))
     :effect (and (predicate4 ?top)
                  (predicate1 ?below)
                  (not (predicate5 ?top ?below))
                  (not (predicate1 ?top))
                  (not (predicate3)))
  )

;; BEGIN EDIT
  (:action action2
     :parameters (?b - object ?s - cluster)
     :precondition (and (predicate4 ?b) (free ?s))
     :effect (and (predicate2 ?b) (predicate1 ?b)
                  (predicate3) (not (predicate4 ?b))
                  (in-cluster ?b ?s)
                  (not (free ?s)))
  )
;; END EDIT

  (:action action3
     :parameters (?top - object ?below - object)
     :precondition (and (predicate4 ?top) (predicate1 ?below))
     :effect (and (predicate5 ?top ?below)
                  (predicate1 ?top)
                  (predicate3)
                  (not (predicate4 ?top))
                  (not (predicate1 ?below)))
  )
)