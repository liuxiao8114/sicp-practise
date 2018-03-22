(define (integral integrand initial-value dt)
  (define int (cons-stream initial-value (add-streams (scale integrand dt) int)))
  int
)
