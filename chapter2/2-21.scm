(load "util.scm")

(define (map proc l)
  (if (null? l)
    '()
    (cons (proc (car l)) (map proc (cdr l)))
  )
)

(define (square-l l)
  (map square l))

(square-l (list 1 2 3))
