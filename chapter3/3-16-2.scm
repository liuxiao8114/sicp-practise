(define one (list 1))

(define three (cons one one))

(define seven (cons three three))

(define (count-pairs x)
  (if (not (pair? x))
    0
    (+ (count-pairs (car x)) (count-pairs (cdr x)) 1)
  )
)

;(count-pairs (cons three 1))

(define (count-pairs-improve x)
  (define (iter x memo-list)
    (if (and (pair? x) (false? (memq x memo-list)))
      (iter (car x) (iter (cdr x) (cons x memo-list)))
      memo-list
    )
  )
  (length (iter x '()))
)

(count-pairs-improve (cons three 1))
