(define (map proc l)
  (if (null? l)
    '()
    (cons (proc (car l)) (map proc (cdr l)))
  )
)

(define (scale-tree t factor)
  (map
    (lambda (x)
      (cond ((pair? x) (scale-tree x factor))
            (else (* x factor)))) t)
)

(scale-tree (list 1 (list 2 (list 3 4 5))) 10)
