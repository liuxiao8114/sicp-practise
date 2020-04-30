(load "util.scm")

(define (stream-limit stream tolerance)
  (let ((s0 (stream-ref stream 0))
        (s1 (stream-ref stream 1)))
    (if (< (abs (- s0 s1)) tolerance)
      s1
      (stream-limit (stream-cdr stream) tolerance)
    )
  )
)

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses
    (cons-stream 1.0
      (stream-map (lambda (guess) (sqrt-improve guess x)) guesses)
    )
  )
  guesses
)

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))
  )
)

;test case:
(sqrt 2 0.00001)
