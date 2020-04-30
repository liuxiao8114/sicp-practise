; a)数据导向区分操作类型和表达式类型
; 在number和variable下，操作类型的表达式(计算过程)已经是常量,没有必要增加导向矩阵的内容

;        +   -   *   /
; deriv

(define (=number? x y)
  (and (number? x) (number? y) (= x y))
)

(define (variable? x)
  (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

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
      (make-sum
        (deriv (addend exp) var)
        (deriv (augend exp) var)
      )
    )
  )
  'done
)

(define (install-product-package)
  (define (multiplier exp) (car exp))
  (define (multiplicand exp) (cadr exp))
  (define (make-product x y)
    (cond ((and (number? x) (number? y)) (* x y))
          ((or (=number? x 0) (=number? y 0)) 0)
          ((=number? x 1) y)
          ((=number? y 1) x)
          (else (attach-tag '* (list x y)))
    )
  )

  (put 'multiplier '* multiplier)
  (put 'multiplicand '* multiplicand)
  (put 'make-product '* make-product)
  (put 'deriv '*
    (lambda (exp var)
      (make-sum
        (make-product (multiplier exp) (deriv (multiplicand exp) var))
        (make-product (deriv (multiplier exp) var) (multiplicand exp))
      )
    )
  )
  'done
)

(install-sum-package)
(install-product-package)

(define (make-sum x y)
  ((get 'make-sum '+) x y))

(define (make-product x y)
  ((get 'make-product '*) x y))

;2018/1/4 由于闭包的存在,在调用deriv时并不调用外部定义的addend等函数
;这些函数的定义,仅为外部调用时提供访问内部定义的接口
;(define (addend lst)
;  ((get 'addend '+) lst))

;(define (multiplier lst)
;  ((get 'multiplier '*) lst))

;(define (multiplicand sum)
;  ((get 'multiplicand '*) lst))

;test case:
;1. test basic make-sum --OK
;(make-sum 1 2)
;(make-sum 1 'x)
;(make-sum 0 'y)

;2. test deriv with only sum --OK
;(deriv (make-sum 1 'x) 'x)
;(deriv (make-sum (make-sum 1 'x) 'x) 'x)
;(deriv (make-sum (make-sum 1 'x) 3) 'x)

;3. test basic make-product --OK
;(make-product 2 5)
;(make-product 3 'x)

;4. test deriv with only product --OK(though not the simplest form)
;(deriv (make-product 2 'x) 'x)
;(deriv (make-product (make-product 2 'x) (make-product 3 'x)) 'x)

;5. test deriv with product and sum mixed --OK(though not the simplest form)
;(deriv '(+ (* 2 x) (+ x 1) 1) 'x)
;(deriv '(* (+ x 2) (* x (* 3 x))) 'x)
