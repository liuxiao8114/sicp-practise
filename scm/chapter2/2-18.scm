(define (reverse l)
  (define (iter l result)
    (if (null? l)
      result
      (iter (cdr l) (cons (car l) result))
    )
  )
  (iter l '())
)

(reverse (list 1 2 3 4))
