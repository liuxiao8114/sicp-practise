;done in 2-5-1.scm, test case only
(load "2-5-1.scm")

(install-scheme-number-package)
(install-rational-package)
;(equ? 1 2)
(equ? (make-rational 3 5) (make-rational 6 10))
