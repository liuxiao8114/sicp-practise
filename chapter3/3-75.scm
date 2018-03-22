(define (make-zero-crossings input-stream last-value)
  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
    (cons-stream
      (sign-change-detector avpt last-value)
      (make-zero-crossings (stream-cdr input-stream) avpt)
    )
  )
)

; extract the zero crossings from the signal constructed 
; by averaging each value of the sense data with the previous value
(define (make-zero-crossings input-stream last-value last-avpt)
  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
    (cons-stream
      (sign-change-detector avpt last-avpt)
      (make-zero-crossings (stream-cdr input-stream) (stream-car input-stream) avpt)
    )
  )
)
