(define (domain mystery_blocksworld)
;; CONSTRAINT Once you start performing , no cluster may surpass a height of 3 objects.
  (:requirements :strips)
  (:predicates
    (predicate1 ?x)    
    (predicate2 ?x)  
    (predicate5 ?x ?y) 
    (predicate4 ?x)  
    (predicate3)           
;; BEGIN ADD
    (h1 ?x)       
    (h2 ?x)       
    (h3 ?x)
    (h4 ?x)
    (h5 ?x)
;; END ADD
    )      

  (:action action1
    :parameters (?b)
    :precondition (and (predicate1 ?b) (predicate2 ?b) 
;; BEGIN ADD
    (h1 ?b) 
;; END ADD
    (predicate3))
    :effect (and (predicate4 ?b)
            (not (predicate2 ?b)) (not (predicate1 ?b)) (not (predicate3))
;; BEGIN ADD
            (not (h1 ?b)) (not (h2 ?b)) (not (h3 ?b)) (not (h4 ?b)) (not (h5 ?b))
;; END ADD
            ))        

  (:action action2
    :parameters (?b)
    :precondition (predicate4 ?b)
    :effect (and (predicate1 ?b) (predicate2 ?b) (predicate3)
                 (not (predicate4 ?b))
;; BEGIN ADD
                 (h1 ?b) (not (h2 ?b)) (not (h3 ?b)) (not (h4 ?b)) (not (h5 ?b))
;; END ADD
                 ))


(:action action3
  :parameters (?b ?c)
  :precondition (and (predicate4 ?b) (predicate1 ?c) 
;; BEGIN ADD
    (or (h1 ?c) (h2 ?c))
;; END ADD
  )
  :effect (and 
    (predicate5 ?b ?c)
    (predicate1 ?b)
    (predicate3)
    (not (predicate1 ?c))
    (not (predicate4 ?b))
;; BEGIN ADD
    (when (h1 ?c)
      (and (h2 ?b)
           (not (h1 ?b))
           (not (h3 ?b))
           (not (h4 ?b))
           (not (h5 ?b))))
    
    (when (h2 ?c)
      (and (h3 ?b)
           (not (h1 ?b))
           (not (h2 ?b))
           (not (h4 ?b))
           (not (h5 ?b))))
;; END ADD
  )
)

  (:action action4
    :parameters (?b ?c)
    :precondition (and (predicate5 ?b ?c) (predicate1 ?b) (predicate3))
    :effect (and (predicate4 ?b) (predicate1 ?c)
                 (not (predicate5 ?b ?c)) (not (predicate1 ?b)) (not (predicate3))
;; BEGIN ADD
                 (not (h1 ?b)) (not (h2 ?b)) (not (h3 ?b)) (not (h4 ?b)) (not (h5 ?b))
;; END ADD
                 ))
)
