(define (pairs s t)
  (cons-stream (list (stream-car s) (stream-car t))
    (interleave
      (interleave
        (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
        (stream-map (lambda (x) (list x (stream-car s))) (stream-cdr t))
      )
      (pairs (stream-cdr s) (stream-cdr t))
    )
  )
)

(define (interleave s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream (stream-car s1) (interleave s2 (stream-cdr s1)))
  )
)

;test case:
(define (stream-for-each-another proc s k n)
  (if (or (stream-null? s) (= k n))
    'done
    (begin
      (proc (stream-car s))
      (stream-for-each-another proc (stream-cdr s) (+ k 1) n)
    )
  )
)

(define (display-stream s)
  (stream-for-each-another display-line s 1 50))

(define (display-line x)
  (newline)
  (display x))

(define one (cons-stream 1 one))
(define (add-stream s1 s2) (stream-map + s1 s2))
(define integers (cons-stream 1 (add-stream one integers)))

(display-stream (pairs integers integers))
