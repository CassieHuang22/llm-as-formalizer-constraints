(define (domain blocksworld)
;; CONSTRAINT The weight of each block is its number. Once you start moving blocks, the total weight above a block should not exceed the weight of the block itself.
  (:requirements :strips)
  (:predicates
        (on ?x ?y)
        (on-table ?x)
        (clear ?x)
        (holding ?x)
        (arm-empty)
;; BEGIN ADD
        (w1 ?x)  (w2 ?x)  (w3 ?x) (w4 ?x) (w5 ?x) (w6 ?x) (w7 ?x) (w8 ?x)
        (cap0 ?x) (cap1 ?x) (cap2 ?x) (cap3 ?x) (cap4 ?x) (cap5 ?x) (cap6 ?x) (cap7 ?x) (cap8 ?x)
;; END ADD
        )

  (:action pickup            
     :parameters (?b)
     :precondition (and (on-table ?b) (clear ?b) (arm-empty))
     :effect (and (holding ?b)
                  (not (on-table ?b))
                  (not (arm-empty))))

  (:action putdown   
     :parameters (?b)
     :precondition (holding ?b)
     :effect (and (on-table ?b) (clear ?b)
                  (arm-empty) (not (holding ?b))))

(:action stack
  :parameters (?t ?b)
  :precondition (and (holding ?t) (clear ?b)
;; BEGIN ADD
                     (or (w1 ?t) (w2 ?t) (w3 ?t) (w4 ?t) (w5 ?t) (w6 ?t) (w7 ?t) (w8 ?t))
                     (or (cap1 ?b) (cap2 ?b) (cap3 ?b) (cap4 ?b) (cap5 ?b) (cap6 ?b) (cap7 ?b) (cap8 ?b))
;; END ADD
                     )
  :effect (and
    (on ?t ?b)
    (clear ?t)
    (arm-empty)
    (not (holding ?t))
    (not (clear ?b))
;; BEGIN ADD
    (when (and (w1 ?t) (cap1 ?b)) (and (not (cap1 ?b)) (cap0 ?b)))
    (when (and (w1 ?t) (cap2 ?b)) (and (not (cap2 ?b)) (cap1 ?b)))
    (when (and (w1 ?t) (cap3 ?b)) (and (not (cap3 ?b)) (cap2 ?b)))
    (when (and (w1 ?t) (cap4 ?b)) (and (not (cap4 ?b)) (cap3 ?b)))
    (when (and (w1 ?t) (cap5 ?b)) (and (not (cap5 ?b)) (cap4 ?b)))
    (when (and (w1 ?t) (cap6 ?b)) (and (not (cap6 ?b)) (cap5 ?b)))
    (when (and (w1 ?t) (cap7 ?b)) (and (not (cap7 ?b)) (cap6 ?b)))
    (when (and (w1 ?t) (cap8 ?b)) (and (not (cap8 ?b)) (cap7 ?b)))

    (when (and (w2 ?t) (cap2 ?b)) (and (not (cap2 ?b)) (cap0 ?b)))
    (when (and (w2 ?t) (cap3 ?b)) (and (not (cap3 ?b)) (cap1 ?b)))
    (when (and (w2 ?t) (cap4 ?b)) (and (not (cap4 ?b)) (cap2 ?b)))
    (when (and (w2 ?t) (cap5 ?b)) (and (not (cap5 ?b)) (cap3 ?b)))
    (when (and (w2 ?t) (cap6 ?b)) (and (not (cap6 ?b)) (cap4 ?b)))
    (when (and (w2 ?t) (cap7 ?b)) (and (not (cap7 ?b)) (cap5 ?b)))
    (when (and (w2 ?t) (cap8 ?b)) (and (not (cap8 ?b)) (cap6 ?b)))

    (when (and (w3 ?t) (cap3 ?b)) (and (not (cap3 ?b)) (cap0 ?b)))
    (when (and (w3 ?t) (cap4 ?b)) (and (not (cap4 ?b)) (cap1 ?b)))
    (when (and (w3 ?t) (cap5 ?b)) (and (not (cap5 ?b)) (cap2 ?b)))
    (when (and (w3 ?t) (cap6 ?b)) (and (not (cap6 ?b)) (cap3 ?b)))
    (when (and (w3 ?t) (cap7 ?b)) (and (not (cap7 ?b)) (cap4 ?b)))
    (when (and (w3 ?t) (cap8 ?b)) (and (not (cap8 ?b)) (cap5 ?b)))

    (when (and (w4 ?t) (cap4 ?b)) (and (not (cap4 ?b)) (cap0 ?b)))
    (when (and (w4 ?t) (cap5 ?b)) (and (not (cap5 ?b)) (cap1 ?b)))
    (when (and (w4 ?t) (cap6 ?b)) (and (not (cap6 ?b)) (cap2 ?b)))
    (when (and (w4 ?t) (cap7 ?b)) (and (not (cap7 ?b)) (cap3 ?b)))
    (when (and (w4 ?t) (cap8 ?b)) (and (not (cap8 ?b)) (cap4 ?b)))

    (when (and (w5 ?t) (cap5 ?b)) (and (not (cap5 ?b)) (cap0 ?b)))
    (when (and (w5 ?t) (cap6 ?b)) (and (not (cap6 ?b)) (cap1 ?b)))
    (when (and (w5 ?t) (cap7 ?b)) (and (not (cap7 ?b)) (cap2 ?b)))
    (when (and (w5 ?t) (cap8 ?b)) (and (not (cap8 ?b)) (cap3 ?b)))

    (when (and (w6 ?t) (cap6 ?b)) (and (not (cap6 ?b)) (cap0 ?b)))
    (when (and (w6 ?t) (cap7 ?b)) (and (not (cap7 ?b)) (cap1 ?b)))
    (when (and (w6 ?t) (cap8 ?b)) (and (not (cap8 ?b)) (cap2 ?b)))

    (when (and (w7 ?t) (cap7 ?b)) (and (not (cap7 ?b)) (cap0 ?b)))
    (when (and (w7 ?t) (cap8 ?b)) (and (not (cap8 ?b)) (cap1 ?b)))

    (when (and (w8 ?t) (cap8 ?b)) (and (not (cap8 ?b)) (cap0 ?b)))
;; END ADD
  )
)


 (:action unstack
  :parameters (?t ?b)
  :precondition (and (on ?t ?b) (clear ?t) (arm-empty)
;; BEGIN ADD
                     (or (w1 ?t) (w2 ?t) (w3 ?t) (w4 ?t) (w5 ?t) (w6 ?t) (w7 ?t) (w8 ?t))
                     (or (cap0 ?b) (cap1 ?b) (cap2 ?b) (cap3 ?b) (cap4 ?b) (cap5 ?b) (cap6 ?b) (cap7 ?b))
;; END ADD
                     )
  :effect (and
    (holding ?t)
    (clear ?b)
    (not (on ?t ?b))
    (not (clear ?t))
    (not (arm-empty))
;; BEGIN ADD
    (when (and (w1 ?t) (cap0 ?b)) (and (not (cap0 ?b)) (cap1 ?b)))
    (when (and (w1 ?t) (cap1 ?b)) (and (not (cap1 ?b)) (cap2 ?b)))
    (when (and (w1 ?t) (cap2 ?b)) (and (not (cap2 ?b)) (cap3 ?b)))
    (when (and (w1 ?t) (cap3 ?b)) (and (not (cap3 ?b)) (cap4 ?b)))
    (when (and (w1 ?t) (cap4 ?b)) (and (not (cap4 ?b)) (cap5 ?b)))
    (when (and (w1 ?t) (cap5 ?b)) (and (not (cap5 ?b)) (cap6 ?b)))
    (when (and (w1 ?t) (cap6 ?b)) (and (not (cap6 ?b)) (cap7 ?b)))
    (when (and (w1 ?t) (cap7 ?b)) (and (not (cap7 ?b)) (cap8 ?b)))

    (when (and (w2 ?t) (cap0 ?b)) (and (not (cap0 ?b)) (cap2 ?b)))
    (when (and (w2 ?t) (cap1 ?b)) (and (not (cap1 ?b)) (cap3 ?b)))
    (when (and (w2 ?t) (cap2 ?b)) (and (not (cap2 ?b)) (cap4 ?b)))
    (when (and (w2 ?t) (cap3 ?b)) (and (not (cap3 ?b)) (cap5 ?b)))
    (when (and (w2 ?t) (cap4 ?b)) (and (not (cap4 ?b)) (cap6 ?b)))
    (when (and (w2 ?t) (cap5 ?b)) (and (not (cap5 ?b)) (cap7 ?b)))
    (when (and (w2 ?t) (cap6 ?b)) (and (not (cap6 ?b)) (cap8 ?b)))

    (when (and (w3 ?t) (cap0 ?b)) (and (not (cap0 ?b)) (cap3 ?b)))
    (when (and (w3 ?t) (cap1 ?b)) (and (not (cap1 ?b)) (cap4 ?b)))
    (when (and (w3 ?t) (cap2 ?b)) (and (not (cap2 ?b)) (cap5 ?b)))
    (when (and (w3 ?t) (cap3 ?b)) (and (not (cap3 ?b)) (cap6 ?b)))
    (when (and (w3 ?t) (cap4 ?b)) (and (not (cap4 ?b)) (cap7 ?b)))
    (when (and (w3 ?t) (cap5 ?b)) (and (not (cap5 ?b)) (cap8 ?b)))

    (when (and (w4 ?t) (cap0 ?b)) (and (not (cap0 ?b)) (cap4 ?b)))
    (when (and (w4 ?t) (cap1 ?b)) (and (not (cap1 ?b)) (cap5 ?b)))
    (when (and (w4 ?t) (cap2 ?b)) (and (not (cap2 ?b)) (cap6 ?b)))
    (when (and (w4 ?t) (cap3 ?b)) (and (not (cap3 ?b)) (cap7 ?b)))
    (when (and (w4 ?t) (cap4 ?b)) (and (not (cap4 ?b)) (cap8 ?b)))

    (when (and (w5 ?t) (cap0 ?b)) (and (not (cap0 ?b)) (cap5 ?b)))
    (when (and (w5 ?t) (cap1 ?b)) (and (not (cap1 ?b)) (cap6 ?b)))
    (when (and (w5 ?t) (cap2 ?b)) (and (not (cap2 ?b)) (cap7 ?b)))
    (when (and (w5 ?t) (cap3 ?b)) (and (not (cap3 ?b)) (cap8 ?b)))

    (when (and (w6 ?t) (cap0 ?b)) (and (not (cap0 ?b)) (cap6 ?b)))
    (when (and (w6 ?t) (cap1 ?b)) (and (not (cap1 ?b)) (cap7 ?b)))
    (when (and (w6 ?t) (cap2 ?b)) (and (not (cap2 ?b)) (cap8 ?b)))

    (when (and (w7 ?t) (cap0 ?b)) (and (not (cap0 ?b)) (cap7 ?b)))
    (when (and (w7 ?t) (cap1 ?b)) (and (not (cap1 ?b)) (cap8 ?b)))

    (when (and (w8 ?t) (cap0 ?b)) (and (not (cap0 ?b)) (cap8 ?b)))
;; END ADD
  )
)
)