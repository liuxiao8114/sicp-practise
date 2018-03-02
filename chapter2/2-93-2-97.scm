(load "2-4-3.scm") ;引入install-rect-package 和 install-pola-package

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (equ? x y) (apply-generic 'equ? x y)) ;practise2.79
(define (=zero? x) (apply-generic '=zero? x)) ;practise2.80

(define (install-scheme-number-package)
  (define (tag x) (attach-tag 'scheme-number x))
  (define (gcd-integers a b)
    (if (= b 0)
        a
        (gcd b (remainder a b))))

  (define (reduce-integers n d)
    (let ((g (gcd n d)))
      (list (/ n g) (/ d g))))

  (put 'add '(scheme-number scheme-number) (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number) (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number) (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number) (lambda (x y) (tag (/ x y))))
  (put 'equ? '(scheme-number scheme-number) (lambda (x y) (= x y)))  ;practise2.79
  (put '=zero? '(scheme-number) (lambda (x) (= x 0)))  ;practise2.80
  (put 'gcd '(scheme-number scheme-number) gcd-integers) ;practise2.93
  (put 'reduce '(scheme-number scheme-number) reduce-integers) ;practise2.93
  (put 'make 'scheme-number (lambda (x) (tag x)))
  'done
)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(define (install-rational-package)
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d))) (cons (/ n g) (/ d g))))

  (define (add-rat x y) (make-rat (+ (* (numer x) (denom y)) (* (numer y) (denom x))) (* (denom x) (denom y))))
  (define (sub-rat x y) (make-rat (- (* (numer x) (denom y)) (* (numer y) (denom x))) (* (denom x) (denom y))))
  (define (mul-rat x y) (make-rat (* (numer x) (numer y)) (* (denom x) (denom y))))
  (define (div-rat x y) (make-rat (* (numer x) (denom y)) (* (denom x) (numer y))))

  (define (equ?-rat x y) (and (= (numer x) (numer y)) (= (denom x) (denom y))))
  (define (=zero?-rat x) (= (numer x) 0))

  (define (tag x) (attach-tag 'rational x))

  (put 'add '(rational rational) (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational) (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational) (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational) (lambda (x y) (tag (div-rat x y))))

  ;for practise2.79 & 2.80
  (put 'equ? '(rational rational) (lambda (x y) (equ?-rat x y)))
  (put '=zero? '(rational) (lambda (x) (=zero?-rat x)))

  (put 'make 'rational (lambda (x y) (tag (make-rat x y))))

  ;for practise2.85
  (put 'numer 'rational numer)
  (put 'denom 'rational denom)

  'done
)

(define (install-rational-package)
  (define (numer x) (car x))
  (define (denom x) (cdr x))

  (define (make-rat n d)
    (cons n d))

  (define (add-rat x y) (make-rat (add (mul (numer x) (denom y)) (mul (numer y) (denom x))) (mul (denom x) (denom y))))
  (define (sub-rat x y) (make-rat (- (* (numer x) (denom y)) (* (numer y) (denom x))) (* (denom x) (denom y))))
  (define (mul-rat x y) (make-rat (* (numer x) (numer y)) (* (denom x) (denom y))))
  (define (div-rat x y) (make-rat (* (numer x) (denom y)) (* (denom x) (numer y))))

  (define (equ?-rat x y) (and (= (numer x) (numer y)) (= (denom x) (denom y))))
  (define (=zero?-rat x) (equ? (numer x) 0))

  (define (tag x) (attach-tag 'rational x))

  (put 'add '(rational rational) (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational) (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational) (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational) (lambda (x y) (tag (div-rat x y))))
  (put 'equ? '(rational rational) (lambda (x y) (equ?-rat x y)))
  (put '=zero? '(rational) (lambda (x) (=zero?-rat x)))

  (put 'make 'rational (lambda (x y) (tag (make-rat x y))))
  (put 'numer 'rational numer)
  (put 'denom 'rational denom)

  'done
)

(define (install-polynomial-package)
  (define (tag x) (attach-tag 'polynomial x))

  (define (make-poly variable term-list)
    (cons variable term-list))

  (define (variable p)
    (if (pair? p)
      (car p)
      (error "what the fuck! variable -- " p)
    )
  )
  (define (term-list p)
    (if (pair? p)
      (cdr p)
      (error "what the fuck! term-list -- " p)
    )
  )

  (define (negation p)
    (make-poly
      (variable p)
      (map
        (lambda (t) (make-term (order t) (- 0 (coeff t))))
        (term-list p)))
  )

  (define (=zero? p)
    (define (iter l)
      (cond ((null? (car p)) true)
            ((not (= (cadr l) 0)) false)
            (else (iter (cdr l))))
    )
    (iter (term-list p))
  )

  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1) (add-terms (term-list p1) (term-list p2)))
      (error "Polys not in same var -- ADD-POLY" (list p1 p2))
    )
  )

  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1) (mul-terms (term-list p1) (term-list p2)))
      (error "Polys not in same var -- MUL-POLY" (list p1 p2))
    )
  )

  (define (div-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
      (let ((result (div-terms (term-list p1) (term-list p2))))
        (cond ((and (empty-termlist? (car result)) (empty-termlist? (cadr result))) 0)
              ((empty-termlist? (cadr result)) (tag (make-poly (variable p1) result)))
              (else (cons (variable p1) result))
        )
      )
      (error "not same variable : " (list p1 p2))
    )
  )

  ;practise2.93
  (define (gcd-poly a b)
    (if (same-variable? (variable a) (variable b))
      (let ((gcd-result (gcd-terms (term-list a) (term-list b))))
        (if (and (= 0 (caar gcd-result)) (= 1 (length gcd-result)))
          (cadr (car gcd-result)) ;if结果为常系数时化简
          (tag (make-poly (variable a) gcd-result))
        )
      )
      (error "Polys not in same var -- GCD-POLY " (list a b))
    )
  )

  (put 'add '(polynomial polynomial) (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial) (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'sub '(polynomial polynomial) (lambda (p1 p2) (tag (add-poly p1 (negation p2)))))
  (put 'div '(polynomial polynomial) (lambda (p1 p2) (div-poly p1 p2))) ;no need tag because remainder
  (put 'equ? '(polynomial polynomial) (lambda (p1 p2) (equ? p1 p2)))
  (put 'gcd '(polynomial polynomial) (lambda (p1 p2) (gcd-poly p1 p2))) ;inside tag process
  (put '=zero? '(polynomial) (lambda (p) (=zero? p)))
  (put 'make 'polynomial (lambda (var terms) (tag (make-poly var terms))))
)

(define (variable? x)
  (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (empty-termlist? l)
  (or (null? l) (null? (car l))))

(define (the-empty-termlist) '())

(define (make-term order coeff)
  (list order coeff))

(define (first-term l) (car l))

(define (rest-terms l) (cdr l))

(define (order t) (car t))

(define (coeff t) (cadr t))

(define (adjoin-term t l)
  (if (=zero? (coeff t))
    l
    (cons t l)))

(define (add-terms l1 l2)
  (cond ((empty-termlist? l1) l2)
        ((empty-termlist? l2) l1)
        (else
          (let ((t1 (first-term l1)) (t2 (first-term l2)))
            (cond ((< (order t1) (order t2)) (adjoin-term t2 (add-terms l1 (rest-terms l2))))
                  ((> (order t1) (order t2)) (adjoin-term t1 (add-terms (rest-terms l1) l2)))
                  (else (adjoin-term
                          (make-term (order t1) (add (coeff t1) (coeff t2)))
                          (add-terms (rest-terms l1) (rest-terms l2))))
            )
          )
        )
  )
)

(define (mul-terms l1 l2)
  (if (or (empty-termlist? l1) (empty-termlist? l2))
    (the-empty-termlist)
    (add-terms
      (mul-term-by-all-terms (first-term l1) l2)
      (mul-terms (rest-terms l1) l2))
  )
)

(define (mul-term-by-all-terms t l)
  (if (empty-termlist? l)
    (the-empty-termlist)
    (let ((ft (first-term l)))
         (adjoin-term
           (make-term
             (+ (order t) (order ft))
             (mul (coeff t) (coeff ft)))
           (mul-term-by-all-terms t (rest-terms l))))))

(define (div-terms L1 L2)
  (if (empty-termlist? L1)
     (list (the-empty-termlist) (the-empty-termlist))
     (let ((t1 (first-term L1))
           (t2 (first-term L2)))
       (if (> (order t2) (order t1))
           (list (the-empty-termlist) L1)
           (let ((new-c (div (coeff t1) (coeff t2)))
                 (new-o (- (order t1) (order t2))))
             (let
               ((rest-of-result (div-terms (add-terms L1 (mul-term-by-all-terms (make-term new-o (- 0 new-c)) L2)) L2)))
               (list (cons (make-term new-o new-c) (car rest-of-result)) (cadr rest-of-result))
             )
           )
       )
     )
  )
)

(define (dispatch-common-factor term-list common-factor action)
  (map (lambda (term) (list (order term) (action (coeff term) common-factor))) term-list)
)

(define (common-factor a b)
  (expt
    (coeff (first-term b))
    (- (+ 1 (order (first-term a))) (order (first-term b))))
)

(define (pseudoremainder-terms a b)
  (let ((common (common-factor a b)))
    (list
      (cadr (div-terms (dispatch-common-factor a common *) b))
      common ;give the common-coeff value , so we can reduce it in gcd-terms
    )
  )
)

(define (remainder-terms a b start-flag)
  (if start-flag
    (pseudoremainder-terms a b)
    (cadr (div-terms a b))
  )
)

(define (gcd-terms a b)
  (define (iter a b start-flag common-factor)
    (if (empty-termlist? b)
      (dispatch-common-factor a common-factor /)
      (if start-flag
        (let ((remainder-result (remainder-terms a b start-flag)))
          (iter b (car remainder-result) false (cadr remainder-result))
        )
        (iter b (remainder-terms a b start-flag) false common-factor)
      )
    )
  )

  (iter a b true 1)
)

(define (make-polynomial var terms)
 ((get 'make 'polynomial) var terms))

(define (gcd a b) (apply-generic 'gcd a b))

(define (reduce-terms l1 l2)
  (let ((common (common-factor a b)))
    ()
  )
)

;test case:
(install-scheme-number-package)
(install-rational-package)
(install-polynomial-package)

(define p1 (make-polynomial 'x '((2 1) (0 1))))
(define p2 (make-polynomial 'x '((3 1) (0 1))))

(define rf (make-rational p2 p1))

; test case for practise 2.94
(define p3 (make-polynomial 'x '((4 1) (3 -1) (2 -2) (1 2))))
(define p4 (make-polynomial 'x '((3 1) (1 -1))))

;(div-terms '((4 1) (3 -1) (2 -2) (1 2)) '((3 1) (1 -1))) ; ((1 -1) ((2 -1) (1 1))
;(div-terms '((3 1) (1 -1)) '((2 -1) (1 1))) ; (((1 -1) (0 -1)) ())
;(div-terms '((4 1) (3 -1) (2 -2) (1 2)) '((2 -1) (1 1))) ; (((1 -1) (0 -1)) ())
;(gcd p3 p4) ;(polynomial x (2 -1) (1 1)) <- or ((2 1) (1 -1)) ???

; test case for practise 2.95 & 2.96
(define p5 (make-polynomial 'x '((2 1) (1 -2) (0 1))))
(define p6 (make-polynomial 'x '((2 11) (0 7))))
(define p7 (make-polynomial 'x '((1 13) (0 5))))

(define Q1 (mul p5 p6)) ;(polynomial x (4 11) (3 -22) (2 18) (1 -14) (0 7))
(define Q2 (mul p5 p7)) ;(polynomial x (3 13) (2 -21) (2 18) (1 3) (0 5))
(gcd Q1 Q2)    ;(polynomial x (2 1458) (1 -2916) (0 1458))

;(gcd Q1 Q2)的调用过程：
;(div Q1 Q2)
