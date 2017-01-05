(load "2-3-4.scm")

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        (else ((get 'deriv (operator exp)) (operands exp) var))
  )
)

(define (operator exp)
  (car exp))

(define (operands exp) (cdr exp))

(define (install-sum-package)
  
    (define (addend exp) (car exp))
  (define (augend exp) (cadr exp))

  (define (make-sum x y)
    (cond ((and (number? x) (number? y)) (+ x y))
          ((=number? x 0) y)
          ((=number? y 0) x)
          (else (attach-tag '+ x y))
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
'done)

(define (make-sum x y)
  ((get 'make-sum '+) x y))

(define (addend sum)
  ((get 'addend '+) sum))

