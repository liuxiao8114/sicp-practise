(define (adjoin-set x s) ;<-- not exactly work
  (cond ((or (null? s) (not (pair? s))) (list x))
        ((< x (car s)) (cons x s))
        ((= x (car s)) s)
        (else (adjoin-set x (cdr s)))
  )
)

(adjoin-set 1 (list 2 3 4 5)) ;output: (3 4 5)

;12/19 rewrite
(define (adjoin-set-b x set)
  (cond ((null? set) (cons x '()))
        ((= x (car set)) set)
        ((< x (car set)) (cons x set))
        (else (cons (car set) (adjoin-set-b x (cdr set))))
  )
)

(adjoin-set-b 3 (list 1 2 4 5)) ;output: (1 2 3 4 5)
;(cons 1 (adjoin-set-b 3 (list 2)))
