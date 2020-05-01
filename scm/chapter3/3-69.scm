;这个解法并不能遍历出全部的勾股数(测试的10组已经out of memory)
;改进方法?
(define (triples s t u)
  (cons-stream
    (list (stream-car s) (stream-car t) (stream-car u))
    (interleave
      (stream-map
        (lambda (pair) (cons (stream-car s) pair))
        (stream-cdr (pairs t u)))
      (triples (stream-cdr s) (stream-cdr t) (stream-cdr u))
    )
  )
)

(define (pairs s t)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (interleave
      (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
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
  (stream-for-each-another display-line s 1 20))

(define (display-line x)
  (newline)
  (display x))

(define one (cons-stream 1 one))
(define (add-stream s1 s2) (stream-map + s1 s2))
(define integers (cons-stream 1 (add-stream one integers)))

(define pythagorean-triples
  (stream-filter
    (lambda (triple) (= (square (caddr triple)) (+ (square (car triple)) (square (cadr triple)))))
    (triples integers integers integers)
  )
)

(display-stream pythagorean-triples)

(define (interleave i j k)
  (cons-stresam
    (list (stream-car i) (stream-car j) (stream-car k))
    (interleave j k (stream-cdr i))
  )
)

(define triple-list )
(define triples
  (stream-filter
    (lambda (l) (= (square (caddr l)) (+ (square (car l)) (square (cadr l)))))
    triple-list
  )
)

(define (integral integrand initial-value dt)
  (define int (cons-stream initial-value (add-streams (scale-stream integrand dt) int)))
  int
)

(define (RC r  c dt)
  ()
)
