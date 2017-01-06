(define (rand type)
  (get type))

(define install-generate-package
  (define generate
    ())
  (put 'generate generate))

(define install-reset-package
  (define reset
    ())
  (put 'reset reset))
