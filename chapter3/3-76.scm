(define (sign-change-detector current last)
  (cond ((and (not (< last 0)) (< current 0)) -1)
        ((and (< last 0) (not (< current 0))) 1)
        (else 0)
  )
)

;implemented like 3-74.scm
(define (make-zero-crossings input-stream smooth)
  (let ((s (smooth input-stream))
    (stream-map sign-change-detector s (cons-stream 0 s))
  )
)

(define (smooth-average s)
  (define (iter-stream stream last-value)
    (cons-stream
      (average (/ (+ (stream-car s) last-value) 2))
      (iter-stream (stream-cdr s) (stream-car s))
    )
  )
  (iter-stream s 0)
)
