
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

(define random-numbers
  (cons-stream init-x (stream-map (lambda (x) (random-dispatch x)) random-numers)))


(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))
  )
)

((stream-ref random-numbers 4) 'generate)

(define (random-)
