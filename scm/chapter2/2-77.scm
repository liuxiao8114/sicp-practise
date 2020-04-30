(load "2-5-1.scm")

(install-rect-package)
(install-complex-package)
;(magnitude (cons 3 4)) <-- wrong! need a tag

;((get 'magnitude '(rect)))
;((get 'make-from-real-imag 'complex) (list 'make-from-real-imag 3 4)) <-- wrong! see the defination of make-from-real-imag 'c

;('complex '(make-from-real-imag 3 4))
;((get 'make-from-real-imag 'complex) 3 4)
;((get 'imag-part '(rect)) (list 1 2))

;(make-from-real-imag 3 4)
;(magnitude (cons 'rect (cons 3 4)))

;题目求值:
;(magnitude (make-complex-from-real-imag 3 4))
;首先迭代化简：
;((get 'make-from-real-imag 'complex) 3 4)
;(tag (make-from-real-imag 3 4))
;(tag ((get 'make-from-real-imag 'rect) 3 4))
;(tag (tag (make-from-real-imag 3 4)))

;迭代为以下形式：
;(magnitude (cons 'complex (cons 'rect (cons 3 4))))
;注意：(list 'complex 'rect (cons 3 4)) is not equal (cons 'complex (cons 'rect (cons 3 4)))

;以下为magnitude的等值变换
(apply-generic 'magnitude (cons 'complex (cons 'rect (cons 3 4))))
(apply magnitude (map contents (list (cons 'complex (cons 'rect (cons 3 4))))))
(apply magnitude (list (cons 'rect (cons 3 4))))
(magnitude (cons 'rect (cons 3 4)))
(apply-generic 'magnitude (cons 'rect (cons 3 4)))
(apply
  (lambda (z) (sqrt (+ (square (car z)) (square (cdr z))))) ;<- 等同于(get 'magnitude 'rect')
  (list (cons 3 4)))

;结论: 2-4-3.scm中的外部定义的 magnitude被调用3次
;(list 1 2 (cons 3 4))
;(magnitude (list 'make-from-mag-ang 5 0.75))
;(imag-part (list 'rect 1 2))
