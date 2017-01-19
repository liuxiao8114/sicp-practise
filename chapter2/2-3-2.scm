(load "util.scm")

(define (filter predicate sequence)
  (cond ((null? sequence) '())
      ((predicate (car sequence))
        (cons (car sequence) (filter predicate (cdr sequence))))
      (else (filter predicate (cdr sequence)))
  )
)

(define (accumulate op init sequence)
  (if(null? sequence)
    init
    (op (car sequence) (accumulate op init (cdr sequence)))))

(define (number0 x)
  (and (number? x) (= x 0)))

(define (number1 x)
  (and (number? x) (= x 1)))

(define (variable? x)
  (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (make-sum a1 a2)
  (cond ((and (number? a1) (number? a2)) (+ a1 a2))
        ((number0 a1) a2)
        ((number0 a2) a1)
        (else (list '+ a1 a2))
  )
)

(define (make-product m1 m2)
  (cond ((and (number? m1) (number? m2)) (* m1 m2))
        ((or (number0 m1) (number0 m2)) 0)
        ((number1 m1) m2)
        ((number1 m2) m1)
        (else (list '* m1 m2))
  )
)

(define (make-product-improve items . params)
  (define (deal-list s)
    (accumulate make-product 1 s)
  )
  (if(null? params)
    (if(pair? items)
      (deal-list items)
      (error "need two params at least")
    )
    (if(pair? items)
      (deal-list (append items params))
      (deal-list (cons items params))
    )
  )
)

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend a) (cadr a))
(define (augend a) (caddr a))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))
(define (multiplicand p) (caddr p))

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '?)))

(define (base x) (cadr x))
(define (exponent x) (caddr x))

(define (make-exp x n)
  (list '? x n))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
          (if (same-variable? exp var) 1 0))
        ((sum? exp)
          (make-sum (deriv (addend exp) var) (deriv (augend exp) var)))
        ((product? exp)
          (make-sum
            (make-product-improve (multiplier exp) (deriv (multiplicand exp) var))
            (make-product-improve (multiplicand exp) (deriv (multiplier exp) var))))
        ((exponentiation? exp)
          (make-product-improve
            (exponent exp) (make-exp (base exp) (- (exponent exp) 1)) (deriv (base exp) var)))
        (else (error "this is liu xiao"))
  )
)

;(deriv '(+ x 3) 'x)
;(deriv '(* x y) 'x)
(deriv '(? (+ (* 2 x) y) 10) 'x)
;(deriv '(* x y (+ x 3)) 'x)
;(make-product-improve (list 'x 'y) 'z '5)
;(make-product-improve (list 10 '(? (+ x y)) 2))
