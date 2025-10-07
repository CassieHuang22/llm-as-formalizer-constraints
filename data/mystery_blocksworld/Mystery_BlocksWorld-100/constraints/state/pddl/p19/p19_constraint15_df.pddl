(define (domain mystery_blocksworld)
;; CONSTRAINT Once you start performing actions on the objects, you must have exactly 5 clusters at any time.
;; BEGIN EDIT
  (:requirements :strips :typing)
;; END EDIT
;; BEGIN ADD
  (:types object cluster)
;; END ADD
  (:predicates
    (predicate1 ?x - object)
    (predicate5 ?x - object ?y - object)
    (predicate2 ?x - object)
    (predicate4 ?x - object)
    (predicate3)
;; BEGIN ADD
    (assigned ?b - object ?s - cluster)
    (used ?s - cluster)
;; END ADD
  )

  (:action action1
;; BEGIN EDIT
    :parameters (?b - object ?s - cluster)
;; END EDIT
    :precondition (and (predicate1 ?b) (predicate2 ?b) (predicate3) 
;; BEGIN ADD
    (assigned ?b ?s)
;; END ADD
    )
    :effect (and (predicate4 ?b)
                 (not (predicate2 ?b))
                 (not (predicate3))
;; BEGIN ADD
                 (not (assigned ?b ?s))
                 (not (used ?s))
;; END ADD
                 )
  )

  (:action action4
;; BEGIN EDIT
    :parameters (?b - object ?x - object ?s - cluster)
;; END EDIT
    :precondition (and (predicate5 ?b ?x) (predicate1 ?b) (predicate3) 
;; BEGIN ADD
    (assigned ?b ?s)
;; END ADD 
    )
    :effect (and (predicate4 ?b)
                 (predicate1 ?x)
                 (not (predicate5 ?b ?x))
;; BEGIN ADD
                 (not (assigned ?b ?s))
;; END ADD
                 (not (predicate3)))
  )

  (:action action3
;; BEGIN EDIT
    :parameters (?b - object ?x - object ?s - cluster)
;; END EDIT
    :precondition (and (predicate4 ?b) (predicate1 ?x) 
;; BEGIN ADD
    (assigned ?x ?s)
;; END ADD
    )
    :effect (and (predicate5 ?b ?x)
                 (predicate1 ?b)
                 (predicate3)
;; BEGIN ADD
                 (assigned ?b ?s)
;; END ADD
                 (not (predicate4 ?b)))
  )

  (:action action2
;; BEGIN EDIT
    :parameters (?b - object ?s - cluster)
    :precondition (and (predicate4 ?b) (not (used ?s)))
;; END EDIT
    :effect (and (predicate2 ?b)
                 (predicate1 ?b)
                 (predicate3)
;; BEGIN ADD
                 (assigned ?b ?s)
                 (used ?s)
;; END ADD
                 (not (predicate4 ?b)))
  )
)
