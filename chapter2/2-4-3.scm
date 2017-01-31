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

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (apply proc (map contents args))
        (error "No methods")
      )
    )
  )
)

(define (install-rect-package)
  (define (real-part z) (car z))
  (define (imag-part z) (cadr z))
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
  (put 'make-from-real-imag '(rect) make-from-real-imag)
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
(install-rect-package)
(imag-part (list 'rect 1 2))
