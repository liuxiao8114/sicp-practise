(load "2-4-3.scm")

; a)数据导向区分操作类型和表达式类型
; 在number和variable下，操作类型的表达式(计算过程)已经是常量,没有必要增加导向矩阵的内容

;        +   -   *   /
; deriv

(define (=number? x y)
  (and (number? x) (number? y) (= x y))
)

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        (else ((get 'deriv (operator exp)) (operands exp) var))
  )
)

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (install-sum-package)
  (define (addend exp) (car exp))
  (define (augend exp) (cadr exp))
  (define (make-sum x y)
    (cond ((and (number? x) (number? y)) (+ x y))
          ((=number? x 0) y)
          ((=number? y 0) x)
          (else (attach-tag '+ (list x y)))
    )
  )

  (put 'addend '+ addend)
  (put 'augend '+ augend)
  (put 'make-sum '+ make-sum)
  (put 'deriv '+
    (lambda (exp var)
      (make-sum (deriv (addend exp) var)
        (deriv (augend exp) var))
    )
  )
  'done
)

(define (make-sum x y)
  ((get 'make-sum '+) x y))

(define (addend sum)
  ((get 'addend '+) sum))

;(deriv '(+ (* 2 x) (+ x 1) 1) 'x)
(install-sum-package)
(deriv (make-sum 1 'x) 'x)
