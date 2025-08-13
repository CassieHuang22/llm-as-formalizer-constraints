(define (domain blocksworld)
;; CONSTRAINT There are 3 robot hands, hand1, hand2 and hand3, so you can move three blocks at a time.
  (:requirements :strips :typing)
;; BEGIN EDIT
  (:types  block  hand)
;; END EDIT
  (:predicates
    (on ?x - block ?y - block)      
    (on-table ?x - block)           
    (clear ?x - block) 
;; BEGIN ADD             
    (hand-empty ?h - hand)          
    (holding ?x - block ?h - hand)
;; END ADD  
  )

  (:action pickup
;; BEGIN EDIT
    :parameters   (?b - block ?h - hand)
;; END EDIT
    :precondition (and (on-table ?b) (clear ?b) 
;; BEGIN EDIT
                        (hand-empty ?h)
;; END EDIT  
                        )
;; BEGIN EDIT
    :effect       (and (holding ?b ?h)
                       (not (on-table ?b))
                       (not (hand-empty ?h)))
;; END EDIT
  )

  (:action putdown
;; BEGIN EDIT
    :parameters   (?b - block ?h - hand)
    :precondition (holding ?b ?h)
    :effect       (and (on-table ?b) (clear ?b)
                       (hand-empty ?h)
                       (not (holding ?b ?h)))
;; END EDIT
  )

  (:action unstack
;; BEGIN EDIT
    :parameters   (?b - block ?c - block ?h - hand)
    :precondition (and (on ?b ?c) (clear ?b) (hand-empty ?h))
    :effect       (and (holding ?b ?h) (clear ?c)
                       (not (on ?b ?c))
                       (not (hand-empty ?h)))
;; END EDIT
  )

  (:action stack
;; BEGIN EDIT
    :parameters   (?b - block ?c - block ?h - hand)
    :precondition (and (holding ?b ?h) (clear ?c))
    :effect       (and (on ?b ?c) (clear ?b)
                       (hand-empty ?h)
                       (not (holding ?b ?h)))
;; END EDIT
  )
)
