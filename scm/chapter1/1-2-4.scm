;1.2.4 Exponentiation
(define (expt b n)
  (if (= n 0)
    1
    (* b (expt b (- n 1)))
  )
)

(define (expt b n)
  (define (expt-iter b n ret)
    (if (= n 0)
      ret
      (expt-iter b (- n 1) (* ret b))
    )
  )

  (expt-iter b n 1)
)

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))
  )
)

(define (even? n)
  (if (= (reminder n 2) 0)
    true
    false
  )
)
