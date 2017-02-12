(define (count-pairs x)
  (if (not (pair? x))
    0
    (+ 1
      (count-pairs (car x))
      (count-pairs (cdr x)))
  )
)

(define two (list 1 2))
(define one (cdr two))

(count-pairs (cons one two))
