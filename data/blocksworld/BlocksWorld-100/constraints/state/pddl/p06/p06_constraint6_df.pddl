(define (domain blocksworld)
;; CONSTRAINT Once you start moving blocks, no stack should be more than 5 blocks high.
  (:requirements :strips)
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
    (h4 ?x)
    (h5 ?x)
    (h6 ?x)
    (h7 ?x)
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
            (not (h1 ?b)) (not (h2 ?b)) (not (h3 ?b)) (not (h4 ?b)) (not (h5 ?b)) (not (h6 ?b)) (not (h7 ?b)) 
;; END ADD
            ))        

  (:action putdown
    :parameters (?b)
    :precondition (holding ?b)
    :effect (and (clear ?b) (on-table ?b) (arm-empty)
                 (not (holding ?b))
;; BEGIN ADD
                 (h1 ?b) (not (h2 ?b)) (not (h3 ?b)) (not (h4 ?b)) (not (h5 ?b)) (not (h6 ?b)) (not (h7 ?b)) 
;; END ADD
                 ))

(:action stack
  :parameters (?b ?c)
  :precondition (and (holding ?b) (clear ?c)
;; BEGIN ADD
                     (or (h1 ?c) (h2 ?c) (h3 ?c) (h4 ?c))
;; END ADD
                     )
  :effect (and
    (on ?b ?c)
    (clear ?b)
    (arm-empty)
    (not (clear ?c))
    (not (holding ?b))
;; BEGIN ADD
    (when (h1 ?c)
      (and (h2 ?b)
           (not (h1 ?b)) (not (h3 ?b)) (not (h4 ?b))))
    
    (when (h2 ?c)
      (and (h3 ?b)
           (not (h1 ?b)) (not (h2 ?b)) (not (h4 ?b))))

    (when (h3 ?c)
      (and (h4 ?b)
           (not (h1 ?b)) (not (h2 ?b)) (not (h3 ?b))))

    (when (h4 ?c)
      (and (h5 ?b)
           (not (h1 ?b)) (not (h2 ?b)) (not (h3 ?b)) (not (h4 ?b))))
;; END ADD
  )
)

  (:action unstack
    :parameters (?b ?c)
    :precondition (and (on ?b ?c) (clear ?b) (arm-empty))
    :effect (and (holding ?b) (clear ?c)
                 (not (on ?b ?c)) (not (clear ?b)) (not (arm-empty))
;; BEGIN ADD
                 (not (h1 ?b)) (not (h2 ?b)) (not (h3 ?b)) (not (h4 ?b)) (not (h5 ?b)) (not (h6 ?b)) (not (h7 ?b))
;; END ADD
                 ))
)
