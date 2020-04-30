(load "3-59.scm")

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream)
)

;method 1
(define (mul-series s1 s2)
  (cons-stream
    (* (stream-car s1) (stream-car s2))
    (add-streams
      (scale-stream (stream-cdr s2) (stream-car s1))
      (mul-series (stream-cdr s1) s2)
    )
  )
)

;method 2
(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
               (add-streams (scale-stream (stream-cdr s2) (stream-car s1))
                                        (mul-series (stream-cdr s1) s2))))

(define s-c
  (add-streams (mul-series sine-series sine-series) (mul-series cosine-series cosine-series))
)

(stream-show s-c 10)
