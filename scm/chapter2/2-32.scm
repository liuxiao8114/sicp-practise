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

;(subsets (list 1 2))的执行过程:
(subsets (list 1 2))

(append (subsets '(2)) (map (lambda (x) (cons 1 x)) (subsets '(2))))

(append
  (append
    (subsets '())
    (map (lambda (x) (cons 2 x)) (subsets '()))
  )
  (map (lambda (x) (cons 1 x)) (subsets '(2)))
)

(append
  (append (list '()) (map (lambda (x) (cons 2 x)) ('())))
  (map (lambda (x) (cons 1 x)) (append ('()) (map (lambda (x) (cons 2 x)) ('())))))

(append (append '('()) '(2)) (map (lambda (x) (cons 1 x)) (append ('()) '(2))))
(append (list '() '(2)) (map (lambda (x) (cons 1 x)) (list '() 2)))
(append (list '() '(2)) (list '(1) '(1 2)))
'('() (2) (1) (1 2))
