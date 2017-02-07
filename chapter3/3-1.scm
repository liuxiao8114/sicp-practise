(define (make-accumulator amount)
  (define (acc m) (set! amount (+ m amount)) amount)
  acc
)

(define (make-accumulator-1 amount)
  (define (acc m) (begin (set! amount (+ m amount)) amount))
  acc
)

(define A (make-accumulator-1 100))

(A 10)
