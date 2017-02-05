(load "util.scm")

;1.定义rect计算包，内部定义各个选择函数，用put公开计算接口(格式：计算名 类名 过程名)
;2.外部定义父类接口，并用get提供具体实现方式
;3.调用时，指定具体调用标记和参数

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
    (car datum)
    (error "Bad tagged datum")
  )
)

(define (contents datum)
  (if (pair? datum)
    (cdr datum)
    (error "Bad contented datum")
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
;^-- wrong! 这里的标志项'rect与上面的'(rect)不同之处在于：带括号是为了适应多参数版本(),如运算中出现的多个对象进行一次性提取
  (put 'make-from-real-imag 'rect (lambda (x y) (tag (make-from-real-imag x y)))) ; <-- why not used same make-complex but make-from-real-imag
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

;(real-part (make-from-real-imag 1 2)) <-- wrong

;test case
;(install-rect-package)
;(imag-part (list 'rect 1 2))
