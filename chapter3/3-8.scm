(define f
  (let ((count 0))
    (lambda (x)
      (if (< 0 count)
        0
        (begin (set! count (+ 1 count)) x)
      )
    )
  )
)
