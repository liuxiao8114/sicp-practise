;; 3.5.4  Streams and Delayed Evaluation
;(define (integral integrand initial-value dt)
;  (define int (cons-stream initial-value (add-streams (scale-stream integrand dt) int)))
;  int
;)

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y
)

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream
      initial-value
      (let ((integrand (force delayed-integrand)))
        (add-streams (scale-stream integrand dt) int)
      )
    )
  )
  int
)

(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))
  )
)

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream)
)

;test case
(stream-ref (solve (lambda (x) x) 1 0.001) 1000)
