(define (integral integrand initial-value dt)
  (define int (cons-stream initial-value (add-streams (scale integrand dt) int)))
  int
)

(define (rand args)
  ((let x (rand-init))
    (cond ((= args 'generate) (lambda () (set! x (rand-update x)) x))
          ((= args 'reset) (lambda (val) (set! x val) x))
          (else (error "Unknown args"))
    )
  )
)

(define (op x)
  (lambda (args)
    (cond ((= args 'generate) (lambda () (rand-update x)))
          ((= args 'reset) (lambda (val) val))
          (else (error "Unknown args"))
    )
  )
)

(define rand-stream
  (cons-stream rand-init (stream-map op rand-stream))
)
