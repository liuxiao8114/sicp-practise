(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (mul-streams s1 s2)
  (stream-map * s1 s2))

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))

(define factorials
  (cons-stream 1 (mul-streams factorials integers)))

(define (stream-ref s n)
  (if (< n 0) ; whose nth element (counting from 0) is n + 1 factorial
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))
  )
)

;test case
(stream-ref factorials 4) ;120
