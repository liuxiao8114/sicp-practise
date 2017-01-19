(load "util.scm")

(define (fringe x) ; wrong -> right
  (cond ((null? x) '())
        ((pair? (car x)) (append (fringe (car x)) (fringe (cdr x)))) ;<--- point!(cons -> append)
        (else (cons (car x) (fringe (cdr x))))
  )
)

(define x (list (list 1 2) (list 3 4)))

(define (fringe-another x)
  (cond ((null? x) '())
        ((not (pair? x)) (list x))
        (else (append (fringe-a (car x)) (fringe-a (cdr x))))
  )
)

(fringe x)
