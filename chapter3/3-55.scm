(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (partial-sums s)
  (cons-stream 0 (add-streams s (partial-sums s)))
)

;test case:
(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))
(define (stream-for-each proc s k n)
  (if (or (stream-null? s) (= k n))
    'done
    (begin
      (proc s)
      (stream-for-each proc (stream-cdr s) (+ k 1) n)
    )
  )
)

(define x (partial-sums integers))

(define (display-line x)
  (newline)
  (display x))

(define (display-stream s n)
  (stream-for-each display-line s 1 n))

(display-stream x 10)

;;2018/03/07 another implement
(define partial-sums
  (cons-stream 0 (add-streams partial-sums integers)))

(define (stream-ref s n)
  (if (= n 0) ; whose nth element (counting from 0) is n + 1 factorial
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))
  )
)

;test case
(stream-ref partial-sums 5) ;15
