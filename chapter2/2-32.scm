(load "util.scm")
(load "2-2-2.scm")

(define (subsets s)
  (if (null? s)
    (list '())
    (let ((rest (subsets (cdr s))))
      (append rest (map (lambda (x) (cons (car s) x)) rest))
    )
  )
)

(subsets (list 1 2 3))
