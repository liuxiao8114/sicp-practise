(define (sum-primes a b)
  (define (iter k sum)
    (cond ((> k b) sum)
          ((prime? k) (iter (+ k 1) (+ sum k)))
          (else (iter (+ k 1) sum))
    )
  )
  (iter a 0)
)

(define (accumulate op initial seq)
  (if (null? seq)
    initial
    (op (car seq) (accumulate op initial (cdr seq)))
  )
)

(define (filter predicate seq)
  (cond ((null? seq) '())
        ((predicate (car seq)) (cons (car seq) (filter predicate (cdr seq))))
        (else (filter predicate (cdr seq)))
  )
)

(define (sum-primes a b)
  (accumulate
    +
    0
    (filter prime? (enum-interval a b))
  )
)

(cons-stream <a> <b>) ;is equivalent to (cons <a> (delay <b>))

(define (stream-car l) (car l))
(define (stream-cdr l) (delay ))

(define (stream-enumerate-interval low high)
  (if (> low high)
    the-empty-stream
    (cons-stream
      low
      (stream-enumerate-interval (+ low 1) high)
    )
  )
)

(stream-car
  (stream-cdr
    (stream-filter prime? (stream-enum-interval 10000 1000000))))

;;The stream implementation in action
