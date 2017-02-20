(define (memo-lib
  (memoize
    (lambda (n)
      (cond ((= n 0) 0)
            ((= n 1) 1)
            (else (+ (memo-lib (- n 1)) (memo-lib (- n 2))))
      )
    )
  ))
)

(define (memoize f)
  (let ((table (make-table)))
    (lambda (x)
      (let ((saved (lookup x table)))
        (or saved
          (let ((result (f x)))
            (insert x result table)
            result
          )
        )
      )
    )
  )
)
