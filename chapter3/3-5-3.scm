;3.5.3  Exploiting the Stream Paradigm
(define (display-stream s)
  (stream-for-each display-line s))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (partial-sums s)
  (cons-stream 0 (add-streams s (partial-sums s)))
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

(display-stream (sqrt-stream 2))

(define (pi-summands n)
  (cons-stream (/ 1.0 n) (stream-map - (pi-summands (+ n 2))))
)

(define pi-stream (scale-stream (partial-sums (pi-summands 1)) 4))

(display-stream pi-stream)
