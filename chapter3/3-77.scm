(define (integral integrand initial-value dt)
  (cons-stream
    initial-value
    (if (stream-null? integrand)
      the-empty-stream
      (integral
        (stream-cdr integrand)
        (+ initial-value (* (stream-car integrand) dt))
        dt
      )
    )
  )
)

(define (integral delayed-integrand initial-value dt)
  (cons-stream
    initial-value
    (let ((integrand (force delayed-integrand)))
      (if (stream-null? integrand)
        the-empty-stream
        (integral
          (delay (stream-cdr integrand))
          (+ initial-value (* (stream-car integrand) dt))
          dt
        )
      )
    )
  )
)

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y
)

(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))
  )
)

;test case:
(stream-ref (solve (lambda (x) x) 1 0.001) 1000)
