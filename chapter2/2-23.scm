(define (for-each proc l)
  (if (null? l)
    #t
    ((proc (car l)) (for-each proc (cdr l)))
  )
)

(for-each (lambda (x) (newline) (display x)) (list 10 100 1000))
