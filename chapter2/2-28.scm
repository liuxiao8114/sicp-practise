(load "util.scm")

(define (fringe x) ; wrong -> right
  (cond ((null? x) '())
        ((pair? (car x)) (append (fringe (car x)) (fringe (cdr x)))) ;<--- point!(cons -> append)
        (else (cons (car x) (fringe (cdr x))))
  )
)

(define x '((1 2) (3 4) 5 6))

(define (fringe-a x)
  (cond ((null? x) '())
        ((not (pair? x)) (list x))
        (else (append (fringe-a (car x)) (fringe-a (cdr x))))
  )
)

(fringe-a (list x x))
