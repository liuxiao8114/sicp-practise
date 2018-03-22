;; 3.5.4  Streams and Delayed Evaluation
;(define (integral integrand initial-value dt)
;  (define int (cons-stream initial-value (add-streams (scale-stream integrand dt) int)))
;  int
;)

(define (solve f y0 dt)
  (define y (integral dy y0 dt))
  (define dy (stream-map f y))
)

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream
      initial-value
      (let ((integrand (force delated-integrand)))
        (add-streams (scale-stream integrand dt) int)
      )
    )
  )
  int
)
