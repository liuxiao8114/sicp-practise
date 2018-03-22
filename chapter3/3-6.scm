(load "util.scm")

(define (rand type)
  (get 'random type))

(define init 10000)

(define install-generate-package
  (put 'random 'generate (random init)))

(define install-reset-package
  (put 'random 'reset (lambda (x) x)))

;(random 10)
(rand 'generate)
;((rand 'reset) 100)

(define rand-msg-passing-ver
  (lambda (type)
    (cond ((eq? type 'generate) (random init))
          ((eq? type 'reset) (lambda (x) x))
          (else (error "unknown type: " type))
    )
  )
)

((rand-msg-passing-ver 'reset) 100)

(define (rand-explicit-dispatch type)
  (cond ((eq? type 'generate) (random init))
        ((eq? type 'reset) (lambda (x) x))
        (else (error "unknown type: " type))
  )
)

(rand-explicit-dispatch 'generate)
