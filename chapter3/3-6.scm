(define (rand type)
  (get type))

(define install-generate-package
  (define generate
    ())
  (put 'generate generate))

(define install-reset-package
  (define reset (lambda (x) x))
  (put 'reset reset))

;(rand 'generate)
;((rand 'reset) 100)
