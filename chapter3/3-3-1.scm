(define (cons x y)
  (define (set-x! v) (set! x v))
  (define (set-y! v) (set! y v))

  (define (dispatch z)
    (cond ((eq? z 'car) x)
          ((eq? z 'cdr) y)
          ((eq? z 'set-car!) set-x!)
          ((eq? z 'set-cdr!) set-y!)
    )
  )
  dispatch
)

(define (car z) (z 'car))
(define (cdr z) (z 'cdr))
(define (set-car! z new-value) (((z 'set-car!) new-value) z))
(define (set-cdr! z new-value) (((z 'set-cdr!) new-value) z))

;test case:
(car (cons 1 2))
(set-car! (cons 1 2) 3)
