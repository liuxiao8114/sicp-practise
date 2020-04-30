
(define (rand type)
  (get 'random type))

(define init 10000)

(define install-generate-package
  (put 'random 'generate (random init)))

(define install-reset-package
  (put 'random 'reset (lambda (x) x)))

(define (random-dispatch x)
  (define (dispatch op)
    (cond ((eq? op 'generate) (random-update x))
          ((eq? op 'reset) x)
          (else (error "Unknown op : " op))
    )
  )
  dispatch
)

;deprecated.
(define random-numbers
  (cons-stream init (stream-map (lambda (x) (random-dispatch x)) random-numers)))

; Produce a stream formulation of this same generator
; that operates on an input stream of requests
(define (rand type-stream)
  (define iter-stream
    (cons-stream
      init
      (stream-map (lambda (type next) ((random-dispatch type) next)) type-stream iter-stream)
    )
  )
  iter-stream
)

(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))
  )
)
