(load "2-2-2.scm")
(load "2-2-3.scm")

(define (count-leaves t)
  (accumulate (lambda (x y) (+ x y)) 0
    (map (lambda (x) (if (pair? x) (count-leaves x) 1)) t)
  )
)

(count-leaves tree-test-2)
