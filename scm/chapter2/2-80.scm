;done in 2-5-1.scm, test case only
(load "2-5-1.scm")

(install-scheme-number-package)
(install-rational-package)
(=zero? (make-rational 0 5))
