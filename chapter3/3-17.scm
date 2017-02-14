(define (count-pairs x)
  (define (iter e l count)
    (if (not (pair? e))
      count
      ()
    )
  )
  (iter x '() 0)
)
