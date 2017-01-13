(define (cons-self x y)
  (define (set-x! v) x v)
  (define (set-y! v) y v)

  (define (dispatch z)
    (cond ((eq? z 'car) x)
          ((eq? z 'cdr) y)
          ((eq? z 'set-car!) set-x!)
          ((eq? z 'set-cdr!) set-y!)
    )
  )
  dispatch
)

(define (car-self z)
  (z 'car))
(define (cdr-self z)
  (z 'cdr))

(car-self (cons-self 1 2))
