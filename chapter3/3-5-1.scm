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
(define (stream-cdr l) (force (cdr l)))

(define (stream-null? l) (null? l))
(define the-empty-stream '())

(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))
  )
)

(define (stream-map proc s)
  (if (stream-null? s)
    the-empty-stream
    (cons-stream
      (proc (stream-car s))
      (stream-map proc (stream-cdr s)))
  )
)

(define (stream-for-each proc s)
  (if (stream-null? s)
    'done
    (begin
      (proc s)
      (stream-for-each proc (stream-cdr s))
    )
  )
)

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
  (display x))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
          (cons-stream (stream-car stream) (stream-filter pred (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))
  )
)

(define (stream-enumerate-interval low high)
  (if (> low high)
    the-empty-stream
    (cons-stream
      low
      (stream-enumerate-interval (+ low 1) high)
    )
  )
)

;;The stream implementation in action
(stream-car
  (stream-cdr
    (stream-filter prime? (stream-enum-interval 10000 100000))))

;step 1: enum
(cons-stream
  10000
  (delay (stream-enumerate-interval 10001 100000)))

;step 2: filter(if not prime)
(stream-cdr (cons-stream 10000 (delay (stream-enumerate-interval 10001 100000))))
(force (delay (stream-enumerate-interval 10001 100000)))
(stream-enumerate-interval 10001 100000)
(cons-stream
  10001
  (delay (stream-enumerate-interval 10002 100000)))

;step 3: filter(if prime)
(stream-cdr
  (cons-stream
    (stream-car (stream-enum-interval 10007 100000))
    (stream-filter pred (stream-cdr (stream-enum-interval 10007 100000)))))


;;Implementing delay and force
(define (force delayed-object)
  (delayed-object))

(define (memo-proc proc)
  (let ((already-run? false)
        (result false))
    (lambda ()
      (if (not already-run?)
        (begin (set! result (proc))
               (set! already-run? true)
               result
        )
        result
      )
    )
  )
)

(define (delay proc) (memo-proc <exp>))
