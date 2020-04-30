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
(define (set-car! z new-value) (((z 'set-car!) new-value) z))
(define (set-cdr! z new-value) (((z 'set-cdr!) new-value) z))

;执行以下:
(define x (cons 1 2))
(define z (cons x x))
(set-car! (cdr z) 17)
(car x)

-----------------------
(全局)
x
z
cons
car
cdr
set-car!
set-cdr!
-----------------------

----------
E1:全局调用(set-car! (cdr z) 17)
z: (cdr z)
new-value: 17
----------

----------
E2:E1中调用(cdr z)
z: (cons x x)
----------

----------
E3: 调用(cons x x)
x: (cons 1 2)

----------
