(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))
  )
)

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

(define (divisible? x y)(= (remainder x y) 0))
(define no-sevens
  (stream-filter (lambda (x) (not (divisible? x 7))) integers))

(define (fibgen a b)
  (cons-stream a (fibgen b (+ a b))))

(define fib (fibgen 0 1))

;self impletation, no delay, out of memory
(define (sieve stream)
  (if (stream-null? stream)
    the-empty-stream
    (sieve
      (stream-filter
        (lambda (x) (not (divisible? x (stream-car stream))))
        (stream-cdr stream)
      )
    )
  )
)

(define (sieve stream)
  (cons-stream
    (stream-car stream)
    (sieve
      (stream-filter
        (lambda (x) (not (divisible? x (stream-car stream))))
        (stream-cdr stream)
      )
    )
  )
)

(define primes (sieve (integers-starting-from 2)))
;(stream-ref primes 50) ;233

;test case
(stream-ref no-sevens 100) ;117
(stream-ref fib 10) ;55
(stream-ref primes 50)

;;Defining streams implicitly
(define ones (cons-stream 1 ones))
;(ones)
;(cons-stream 1 (cons-stream 1 ones))
(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define integers (cons-stream 1 (add-streams ones integers)))

;(add-streams ones integers)
;<=> (cons-stream 2 (stream-map + ones (add-streams ones integers)))

;(integers)
;(cons-stream 1 (stream-map + ones integers))
;(cons-stream
;  1
;  (cons-stream
;    2
;    (apply
;      stream-map
;      (list + ones (add-streams ones integers)))))
;(cons-stream 1 (cons-stream 2 (stream-map + ones (add-streams ones integers)))
;(cons-stream 1 (cons-stream 2 (cons-stream 3 (stream-map + ones (stream-map + ones (add-streams ones integers))))))
;
;
(define fibs
  (cons-stream
    0
    (cons-stream
      1
      (add-streams (streams-cdr fibs) fibs))))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream)
)

(define double (cons-stream 1 (scale-stream double 2)))

(define primes (cons-stream 2 (stream-filter prime? (integers-starting-from 3))))

(define (prime? n)
  (define (iter ps)
    (cond ((> (square (stream-car ps)) n) true)
          ((divisible? n (stream-car ps)) false)
          (else (iter (stream-cdr ps)))
    )
  )
  (iter primes)
)
