(load "2-5-1.scm")

(define (variable? x)
  (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (install-polynomial-package)
  (define (tag x) (attach-tag 'polynomial x))

  (define (make-poly variable term-list)
    (cons variable term-list))

  (define (variable p) (car p))
  (define (term-list p) (cdr p))

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
        (if (and (empty-termlist? (car result)) (empty-termlist? (cadr result)))
          0
          (make-poly (variable p1) result)
        )
      )
      (error "not same variable : " (list p1 p2))
    )
  )

  (put 'add '(polynomial polynomial) (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial) (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'sub '(polynomial polynomial) (lambda (p1 p2) (tag (add-poly p1 (negation p2)))))
  (put 'div '(polynomial polynomial) (lambda (p1 p2) (tag (div-poly p1 p2))))
  (put 'equ? '(polynomial polynomial) (lambda (p1 p2) (equ? p1 p2)))
  (put '=zero? '(polynomial) (lambda (p) (=zero? p)))
  (put 'make 'polynomial (lambda (var terms) (tag (make-poly var terms))))
)

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

(define (make-polynomial var terms)
 ((get 'make 'polynomial) var terms))

;test case:
(install-scheme-number-package)
(install-polynomial-package)
(define p1 (make-polynomial 'x (list (make-term 2 4) (make-term 1 3) (make-term 0 10))))
(define p2 (make-polynomial 'x (list (make-term 1 2) (make-term 0 20))))

;(add p1 p2) ;(polynomial x (2 4) (1 5) (0 30))
;(mul p1 p2) ;(polynomial x (3 8) (2 86) (1 80) (0 200))
;(sub p1 p2) ;(polynomial x (2 4) (1 1) (0 -10))

(define p3 (make-polynomial 'x (list (make-term 5 1) (make-term 0 -1))))
(define p4 (make-polynomial 'x (list (make-term 3 1) (make-term 0 -1))))

(div p3 p4)
