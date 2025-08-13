(define (domain mystery_blocksworld)
;; CONSTRAINT You can now perform sets of actions on 2 objects at a time using 2 new objects, object-a and object-b
  (:requirements :strips :typing)
;; BEGIN EDIT
  (:types object new_object)
;; END EDIT
  (:predicates
    (predicate5 ?x - object ?y - object)      
    (predicate2 ?x - object)           
    (predicate1 ?x - object) 
;; BEGIN ADD             
    (predicate3 ?h - new_object)          
    (predicate4 ?x - object ?h - new_object)
;; END ADD  
  )

  (:action action1
;; BEGIN EDIT
    :parameters   (?b - object ?h - new_object)
;; END EDIT
    :precondition (and (predicate2 ?b) (predicate1 ?b) 
;; BEGIN EDIT
                        (predicate3 ?h)
;; END EDIT  
                        )
;; BEGIN EDIT
    :effect       (and (predicate4 ?b ?h)
                       (not (predicate2 ?b))
                       (not (predicate3 ?h)))
;; END EDIT
  )

  (:action action2
;; BEGIN EDIT
    :parameters   (?b - object ?h - new_object)
    :precondition (predicate4 ?b ?h)
    :effect       (and (predicate2 ?b) (predicate1 ?b)
                       (predicate3 ?h)
                       (not (predicate4 ?b ?h)))
;; END EDIT
  )

  (:action action4
;; BEGIN EDIT
    :parameters   (?b - object ?c - object ?h - new_object)
    :precondition (and (predicate5 ?b ?c) (predicate1 ?b) (predicate3 ?h))
    :effect       (and (predicate4 ?b ?h) (predicate1 ?c)
                       (not (predicate5 ?b ?c))
                       (not (predicate3 ?h)))
;; END EDIT
  )

  (:action action3
;; BEGIN EDIT
    :parameters   (?b - object ?c - object ?h - new_object)
    :precondition (and (predicate4 ?b ?h) (predicate1 ?c))
    :effect       (and (predicate5 ?b ?c) (predicate1 ?b)
                       (predicate3 ?h)
                       (not (predicate4 ?b ?h)))
;; END EDIT
  )
)
