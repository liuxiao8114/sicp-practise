(define (for-each proc l)
  (if (null? l)
    'done
    (begin (proc (car l)) (for-each proc (cdr l)))
  )
)

(define (for-each-another proc l)
  (map
    (lambda (x) (begin (proc x) 'done)) l))

(for-each (lambda (x) (newline) (display x)) (list 10 100 1000))
;(for-each-another (lambda (x) (newline) (display x)) (list 10 100 1000))
