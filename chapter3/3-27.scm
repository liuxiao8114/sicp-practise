(load "util.scm")

(define (memoize f)
  (let ((table (make-table)))
    (lambda (x)
      (let ((saved (get x table)))
        (or saved
          (let ((result (f x)))
            (put x result table)
            result
          )
        )
      )
    )
  )
)

(define memo-fib
  (memoize
    (lambda (n)
      (cond ((= n 0) 0)
            ((= n 1) 1)
            (else (+ (memo-fib (- n 1)) (memo-fib (- n 2))))
      )
    )
  )
)

(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1)) (fib (- n 2))))
  )
)

(memo-fib 3)
((memoize (lambda (n) (...))) 3)
(+ (memo-fib 2) (memo-fib 1)) ; <= result
(+ (memoize (lambda (n) (...)) 2) (memoize (lambda (n) (...)) 1))
