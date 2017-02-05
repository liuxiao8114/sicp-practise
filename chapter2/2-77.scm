(load "2-5-1.scm")

(install-rect-package)
(install-complex-package)
;(magnitude (cons 3 4)) <-- wrong! need a tag

;((get 'magnitude '(rect)) )
;((get 'make-from-real-imag 'complex) (list 'make-from-real-imag 3 4)) <-- wrong! see the defination of make-from-real-imag 'c

;('complex '(make-from-real-imag 3 4))
;((get 'make-from-real-imag 'complex) 3 4)
;((get 'imag-part '(rect)) (list 1 2))

;(make-from-real-imag 3 4)
;(magnitude (cons 'rect (cons 3 4)))

(magnitude (make-complex-from-real-imag 3 4))

;(magnitude (list 'make-from-mag-ang 5 0.75))
;(imag-part (list 'rect 1 2))
