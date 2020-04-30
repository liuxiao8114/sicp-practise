;a.
(define (add-streams s1 s2) (stream-map + s1 s2))
(define integers (cons-stream 1 (add-streams ones integers)))

(define (integrate-series stream)
  (stream-map (lambda (x y) (/ x y)) stream integers)
)

(define (stream-show s n)
  (if (= n 0)
    (cons (stream-car s) '())
    (cons (stream-car s) (stream-show (stream-cdr s) (- n 1)))
  )
)

;test case:
(define ones (cons-stream 1 ones))
(define double (cons-stream 1 (add-streams double double)))
;(stream-show (integrate-series ones) 3) ;(1 1/2 1/3 1/4)
(stream-show (integrate-series double) 3) ;(1 1 4/3 2)

;b.
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream)
)

(define cosine-series
  (cons-stream 1 (integrate-series (scale-stream sine-series -1))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

;cosine-series与sine-series能实现的原因正如正文中的对prime所解释的:
; at any point, enough of the primes stream has been generated
; to test the primality of the numbers we need to check next.
