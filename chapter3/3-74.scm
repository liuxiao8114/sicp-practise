(define (sign-change-detector current last)
  (cond ((and (not (< last 0)) (< current 0)) -1)
        ((and (< last 0) (not (< current 0))) 1)
        (else 0)
  )
)

(define (make-zero-crossings input-stream last-value)
  (cons-stream
    (sign-change-detector (stream-car input-stream) last-value)
    (make-zero-crossings (stream-cdr input-stream) (stream-car input-stream))
  )
)

(define zero-crossings (make-zero-crossings sense-data 0))

(define zero-crossings
  (stream-map sign-change-detector sense-data (cons-stream 0 sense-data))
)
