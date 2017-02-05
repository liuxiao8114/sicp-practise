(load "2-5-1.scm")

(define (equ? x y)
  (apply-generic 'equ? x y))

(install-scheme-number-package)
(install-rational-package)
(equ? (make-rational 3 5) (make-rational 6 8))
