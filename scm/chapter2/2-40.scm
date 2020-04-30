(load "2-2-3.scm")

(define (unique-pairs n)
  (flatmap
    (lambda (x) (map (lambda (y) (list x y)) (enum (- x 1))))
    (enum n)
  )
)

(define (prime-sum-pairs n)
  (map
    make-pair-sum
    (filter
      prime-sum?
      (unique-pairs n)
    )
  )
)

(prime-sum-pairs 10)
