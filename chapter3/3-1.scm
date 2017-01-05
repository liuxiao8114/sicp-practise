(define (make-accumulator amount)
  (define (acc m) (set! amount (+ m amount)) amount)
  acc
)

(define A (make-accumulator 10))

(A 10)
