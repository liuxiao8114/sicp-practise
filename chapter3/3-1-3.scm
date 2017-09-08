(define (make-simplified-withdraw balance)
  (lambda (x) (set! balance (- balance x))
    balance
  )
)

(define (make-decrementer balance)
  (lambda (x) (- balance x)))

(define w1 (make-simplified-withdraw 100))
(define w2 (make-simplified-withdraw 100))
(define m1 (make-decremented 100))
(define m2 (make-decremented 100))

(w1 10) ;90
(w1 10) ;80

(w2 10) ;90

(m1 10) ;90
(m1 10) ;90
