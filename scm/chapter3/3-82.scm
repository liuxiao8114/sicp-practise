(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
      (/ passed (+ passed failed))
      (monte-carlo (stream-cdr experiment-stream) passed failed)
    )
  )

  (if (stream-car experiment-stream)
    (next (+ passed 1) failed)
    (next passed (+ failed 1))
  )
)

(define (p x y)
  (not (< 9 (+ (square (- x 5)) (square (- y 7)))))
)

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random (exact->inexact range)))
  )
)

(define (estimate-integral p x1 x2 y1 y2)
  (define round-test-stream
    (cons-stream
      (p (random-in-range x1 x2) (random-in-range y1 y2))
      round-test-stream
    )
  )

  (scale-stream (monte-carlo round-test-stream 0 0) 4)
)

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream)
)

(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))
  )
)

(stream-ref (estimate-integral p 2 8 4 10) 1000)
