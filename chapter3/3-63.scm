(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (cons-stream
    1.0
    (stream-map (lambda (guess) (sqrt-improve guess x)) (sqrt-stream x))
  )
)

;参考本节log.md
