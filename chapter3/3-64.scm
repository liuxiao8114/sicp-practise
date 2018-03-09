(define (stream-limit stream tolerance)
  ()
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
