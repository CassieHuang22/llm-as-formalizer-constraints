(define (domain mystery_blocksworld)
;; CONSTRAINT Only 20 uses of action1 are allowed in the entire task.
  (:requirements :strips :typing)
;; BEGIN EDIT
  (:types object token)
;; END EDIT
  (:predicates
        (predicate5 ?x - object ?y - object)
        (predicate2  ?x - object)
        (predicate1     ?x - object)
        (predicate4   ?x - object)
        (predicate3)
;; BEGIN ADD
        (unused ?t - token)
;; END ADD
        )

  (:action action1
;; BEGIN EDIT
     :parameters (?b - object ?tok - token)
;; END EDIT
     :precondition (and (predicate2 ?b) (predicate1 ?b) (predicate3)
;; BEGIN ADD
                   (unused ?tok)
;; END ADD        
                    )    
     :effect (and (predicate4 ?b)
                  (not (predicate2 ?b))
                  (not (predicate3))
;; BEGIN ADD
                  (not (unused ?tok))
;; END ADD
                  )          ; token spent
  )

  (:action action4
     :parameters (?top - object ?below - object)
     :precondition (and (predicate5 ?top ?below) (predicate1 ?top) (predicate3))
     :effect (and (predicate4 ?top)
                  (predicate1 ?below)
                  (not (predicate5 ?top ?below))
                  (not (predicate1 ?top))
                  (not (predicate3)))
  )

  (:action action2
     :parameters (?b - object)
     :precondition (predicate4 ?b)
     :effect (and (predicate2 ?b) (predicate1 ?b)
                  (predicate3)
                  (not (predicate4 ?b)))
  )

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