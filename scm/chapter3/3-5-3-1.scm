;3.5.3  Exploiting the Stream Paradigms
;; 3.5.3.1 Formulating iterations as stream processes
(load "util.scm")

(define (stream-for-each-another proc s k n)
  (if (or (stream-null? s) (= k n))
    'done
    (begin
      (proc (stream-car s))
      (stream-for-each-another proc (stream-cdr s) (+ k 1) n)
    )
  )
)

(define (display-stream s)
  (stream-for-each-another display-line s 1 10))

(define (display-line x)
  (newline)
  (display x))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (partial-sums s)
  (define p (cons-stream 0 (add-streams s p)))
  p
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

(define (scale-stream stream k)
  (stream-map (lambda (x) (* x k)) stream)
)

(define (pi-summands n)
  (cons-stream (/ 1.0 n) (stream-map - (pi-summands (+ n 2))))
)

(define pi-stream (scale-stream (partial-sums (pi-summands 1)) 4))

(display-stream pi-stream)

(define (euler-transform s)
  (let ((s0 (stream-ref s 0))
        (s1 (stream-ref s 1))
        (s2 (stream-ref s 2)))
    (cons-stream
      (- s2 (/ (square (- s2 s1)) (+ s0 (* -2 s1) s2)))
      (euler-transform (stream-cdr s))
    )
  )
)

(display-stream (euler-transform pi-stream))

(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s)))
)

(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s))
)

(display-stream (accelerated-sequence euler-transform pi-stream))
