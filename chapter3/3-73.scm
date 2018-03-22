(define (RC R C dt)
  (define (iter-stream input-stream initial-value)
    (add-streams
      (scale-stream input-stream R)
      (cons-stream initial-value (integral (scale-stream input-stream (/ 1 C)) 0 dt))))
  iter-stream
)

(define (integral integrand initial-value dt)
  (define int (cons-stream initial-value (add-streams (scale integrand dt) int)))
  int
)

(define (add-stream s1 s2) (stream-map + s1 s2))

(define RC1 (RC 5 1 0.5))
