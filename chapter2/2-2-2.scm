;2.2.2  Hierarchical Structures
(define (map proc l)
  (if (null? l)
    '()
    (cons (proc (car l)) (map proc (cdr l)))
  )
)

(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))
  )
)

;; Mapping over trees
(define (scale-tree t factor)
  (map
    (lambda (x)
      (cond ((pair? x) (scale-tree x factor))
            (else (* x factor)))) t)
)

(scale-tree (list 1 (list 2 (list 3 4 5))) 10)
