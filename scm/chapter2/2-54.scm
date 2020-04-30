(define (equal? a b)
  (cond ((and (pair? a) (pair? b))
          (if (eq? (car a) (car b))
            (equal? (cdr a) (cdr b))
            false
          )
        )
        ((or (pair? a) (pair? b)) false)
        ((eq? a b) true)
        (else false)
  )
)


(equal? (list 1 2 3) (list 1 2 5))
