(load "util.scm")
;1.定义rect计算包，内部定义各个选择函数，用put公开计算接口(格式：操作名 类型名 过程)
;2.外部定义父类接口，并用get提供具体实现方式
;3.调用时，指定具体调用标记和参数

;2018/02/19 修改attach-tag, type-tag, contents的判断条件简化数的运算
(define (attach-tag type-tag contents)
  (if (number? contents)
    contents
    (cons type-tag contents)
  )
)

(define (type-tag datum)
  (cond ((pair? datum) (car datum))
        ((number? datum) 'scheme-number)
        (else (error "Bad tagged datum: " datum))
  )
)

(define (contents datum)
  (cond ((pair? datum) (cdr datum))
        ((number? datum) datum)
        (else (error "Bad contented datum: " datum))
  )
)

;(apply-generic 'rect '((rect 1 2) (rect 2 3) (ang 3 4)))
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (apply proc (map contents args))
        (error "No methods--" op)
      )
    )
  )
)

;2018/1/3 实际上，下面的这些测试全部报错
;问题在于apply-generic函数用于解包type为'(rect) 这种类型,
;所以args本身必须为pair类型(如:(list 'rect 1 2))
;在正确取得proc( + )之后,调用apply的第二个参数同样也是pair类型,
;相当于(+ '(;pair类型)), 所以必然报错
;(put 'real-part '(rect) +)
;(apply (get 'real-part '(rect)) '(1 2))
;(apply-generic 'real-part (list 'rect 1 2))
;(apply (get 'real-part '(rect)) '(1 2))
;(('rect 1 2) ('rect 2 3))
;(apply-generic 'real-part (list (list 'rect 1 2) (list 'rect 2 3)))

(define (install-rect-package)
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z)) (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))

  (define (tag x) (attach-tag 'rect x))
  (put 'real-part '(rect) real-part)
  (put 'imag-part '(rect) imag-part)
  (put 'magnitude '(rect) magnitude)
  (put 'angle '(rect) angle)
;  (put 'make-from-real-imag '(rect) make-from-real-imag)
;^-- wrong! 这里的标志项'rect与上面的'(rect)不同之处在于：带括号是为了适应多参数版本(如运算中出现的
;多个对象进行一次性提取)
; 需要与外部的make-from-real-imag相匹配(76行能正确get到这里的内部定义)
  (put 'make-from-real-imag 'rect (lambda (x y) (tag (make-from-real-imag x y))))
;^-- why not used same make-complex but make-from-real-imag
  'done
)

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))

(define (make-from-real-imag x y)
  ((get 'make-from-real-imag 'rect) x y))

(define (make-from-mag-ang r a)
  ((get 'make-from-mag-ang 'pola) r a))
;(map contents (list (list 'rect 1 2)))
;(apply + '((1 2)))

;test case
(install-rect-package)
;(imag-part (list 'rect 1 2))
;(angle (list 'rect 1 2))
;(real-part (make-from-real-imag 1 2))
