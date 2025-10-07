(define (domain blocksworld)
;; CONSTRAINT Once you start moving blocks, no stack should be more than 2 blocks high.
  (:requirements :strips)
  (:types block)
  (:predicates
    (clear ?x)    
    (on-table ?x)  
    (on ?x ?y) 
    (holding ?x)  
    (arm-empty)           
;; BEGIN ADD
    (h1 ?x)       
    (h2 ?x) 
    (h3 ?x)
;; END ADD
    )      

  (:action pickup
    :parameters (?b)
    :precondition (and (clear ?b) (on-table ?b) 
;; BEGIN ADD
    (h1 ?b) 
;; END ADD
    (arm-empty))
    :effect (and (holding ?b)
            (not (on-table ?b)) (not (clear ?b)) (not (arm-empty))
;; BEGIN ADD
            (not (h1 ?b)) (not (h2 ?b)) (not (h3 ?b))
;; END ADD
            ))        

  (:action putdown
    :parameters (?b)
    :precondition (holding ?b)
    :effect (and (clear ?b) (on-table ?b) (arm-empty)
                 (not (holding ?b))
;; BEGIN ADD
                 (h1 ?b) (not (h2 ?b)) (not (h3 ?b))
;; END ADD
                 ))

;; BEGIN EDIT
  (:action stack
    :parameters (?b ?c)
    :precondition (and (holding ?b) (clear ?c) 
;; BEGIN ADD
    (h1 ?c)
;; END ADD
    )
    :effect (and (on ?b ?c) (clear ?b) (arm-empty)
                 (not (clear ?c)) (not (holding ?b))
;; BEGIN ADD
                 (h2 ?b)               
                 (not (h1 ?b))
                 (not (h3 ?b))
;; END ADD
                 ))
;; END EDIT

  (:action unstack
    :parameters (?b ?c)
    :precondition (and (on ?b ?c) (clear ?b) (arm-empty))
    :effect (and (holding ?b) (clear ?c)
                 (not (on ?b ?c)) (not (clear ?b)) (not (arm-empty))
;; BEGIN ADD
                 (not (h1 ?b)) (not (h2 ?b)) (not (h3 ?b))
;; END ADD
                 ))
)
