;copy from 3-3-1.scm

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
(define (set-car! z) (z 'set-car!))
(define (set-cdr! z) (z 'set-cdr!))

-----------------------
x
z
cons
car
cdr
set-car!
set-cdr!
-----------------------

----------
E1
----------
