(define (adjoin-set x s)
  (cond ((or (null? s) (not (pair? s))) (list x))
        ((< x (car s)) (cons x s))
        ((= x (car s)) s)
        (else (adjoin-set x (cdr s)))
  )
)

(adjoin-set 1 (list 2 3 4 5))
