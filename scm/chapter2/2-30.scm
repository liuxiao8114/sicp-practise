(load "util.scm")
(load "2-2-2.scm")

(define (square-tree-map t)
  (map (lambda (x) (if (pair? x) (square-tree x) (square x))) t))

(define (square-tree t)
  (cond ((null? t) '())
        ((pair? t) (cons (square-tree (car t)) (square-tree (cdr t))))
        (else (square t))
  )
)

(define x (list 1 (list 2 (list 3 4 5))))

(square-tree x)
