(define (append x y)
  (if (null? x)
    y
    (cons (car x) (append (cdr x) y))
  )
)

(define (last-pair x)
  (if (null? (cdr x))
    x
    (last-pair (cdr x))
  )
)

(define (append! x y)
  (begin (set-cdr! (last-pair x) y) x))


(define x '(a b))
(define y '(c d))

;(append x y)
