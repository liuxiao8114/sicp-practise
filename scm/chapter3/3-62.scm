(load "3-59.scm")
(load "3-61.scm")

(define (div-series s1 s2)
  (if (= 0 (stream-car s2))
    (error "denominator cannot have zero constant: " s2)
    (mul-series s1 (invert-unit-series s2))
  )
)

;what this answer means???
(define (div-series s1 s2)
  (let ((c (stream-car s2)))
    (if (= 0 c)
      (error "denominator cannot have zero constant: " s2)
      (scale-stream
        (mul-series
          s1
          (invert-unit-series (scale-stream s2 (/ 1 c))))
        (/ 1 c)))))

(define (tangent s)
  (div-series sine-series cosine-series))
