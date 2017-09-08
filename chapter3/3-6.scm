(load "util.scm")

(define (rand type)
  (get 'random type))

(define install-generate-package
  (put 'random 'generate (lambda (x) (random x))))

(define install-reset-package
  (put 'random 'reset (lambda (x) x)))

;(random 10)
((rand 'generate) 100)
;((rand 'reset) 100)
