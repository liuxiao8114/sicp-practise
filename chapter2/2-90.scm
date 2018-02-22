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

  (put 'add '(polynomial polynomial) (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial) (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'sub '(polynomial polynomial) (lambda (p1 p2) (tag (add-poly p1 (negation p2)))))
  (put 'equ? '(polynomial polynomial) (lambda (p1 p2) (equ? p1 p2)))
  (put '=zero? '(polynomial) (lambda (p) (=zero? p)))
  (put 'make 'polynomial (lambda (var terms) (tag (make-poly var terms))))
)

(define (install-density-term-list-package)
  (define (tag term) (attach-tag 'density term))
  (define (first-term terms) (car terms))
  (define (rest-terms terms) (cdr terms))
  (define (first-order terms) (- (length terms) 1))

  (define (adjoin-term t l) (cons t l))

  (define (add-density-terms l1 l2)
    (cond ((empty-termlist? l1) l2)
          ((empty-termlist? l2) l1)
          (else
            (let ((t1 (first-term l1)) (t2 (first-term l2)))
              (cond ((< (first-order l1) (first-order l2))
                        (adjoin-term t2 (add-density-terms l1 (rest-terms l2))))
                    ((> (first-order l1) (first-order l2))
                        (adjoin-term t1 (add-density-terms (rest-terms l1) l2)))
                    (else (adjoin-term
                            (add t1 t2) (add-density-terms (rest-terms l1) (rest-terms l2))))
              )
            )
          )
    )
  )

  (define (mul-density-terms l1 l2)
    (if (or (empty-termlist? l1) (empty-termlist? l2))
      (the-empty-termlist)
      (add-density-terms
        (mul-density-term-by-all-terms (first-term l1) (first-order l1) l2)
        (mul-density-terms (rest-terms l1) l2))
    )
  )

  (define (mul-density-term-by-all-terms t order l)
    (if (empty-termlist? l)
        (if (= order 0)
          (the-empty-termlist)
          (adjoin-term 0 (mul-density-term-by-all-terms t (- order 1) l)))
        (adjoin-term
          (mul t (first-term l))
          (mul-density-term-by-all-terms t order (rest-terms l)))))

  (put 'first-term 'density (lambda (terms) (first-term terms)))
  (put 'rest-terms 'density (lambda (terms) (rest-terms terms)))
  (put 'first-order 'density (lambda (terms) (first-order terms)))
  (put 'add-terms 'density (lambda (l1 l2) (add-density-terms l1 l2)))
  (put 'mul-terms 'density (lambda (l1 l2) (mul-density-terms l1 l2)))
  (put 'mul-term-by-all-terms 'density (lambda (t order l) (mul-density-term-by-all-terms t order l)))
)

(define (install-spare-term-list-package)
  (define (first-term l) (car l))
  (define (rest-terms l) (cdr l))
  (define (order t) (car t))
  (define (coeff t) (cadr t))
  (define (make-term order coeff) (list order coeff))

  (define (convert terms)
    (cond ((null? terms) '())
          ((pair? (car terms)) (cons (car terms) (convert (cdr terms))))
          (else (error "not spare-terms in (order coeff) form: " terms))
    )
  )

  (define (adjoin-term t l)
    (if (=zero? (coeff t))
      l
     (cons t l)))

  (define (add-spare-terms l1 l2)
    (cond ((empty-termlist? l1) l2)
          ((empty-termlist? l2) l1)
          (else
            (let ((t1 (first-term l1)) (t2 (first-term l2)))
              (cond ((< (order t1) (order t2)) (adjoin-term t2 (add-spare-terms l1 (rest-terms l2))))
                    ((> (order t1) (order t2)) (adjoin-term t1 (add-spare-terms (rest-terms l1) l2)))
                    (else (adjoin-term
                            (make-term (order t1) (add (coeff t1) (coeff t2)))
                            (add-spare-terms (rest-terms l1) (rest-terms l2))))
              )
            )
          )
    )
  )

  (define (mul-spare-terms l1 l2)
    (if (or (empty-termlist? l1) (empty-termlist? l2))
      (the-empty-termlist)
      (add-spare-terms
        (mul-spare-term-by-all-terms (first-term l1) l2)
        (mul-spare-terms (rest-terms l1) l2))
    )
  )

  (define (mul-spare-term-by-all-terms t l)
    (if (empty-termlist? l)
      (the-empty-termlist)
      (let ((ft (first-term l)))
           (adjoin-term
             (make-term
               (+ (order t) (order ft))
               (mul (coeff t) (coeff ft)))
             (mul-spare-term-by-all-terms t (rest-terms l))))))

  (put 'first-term 'spare (lambda (terms) (first-term terms)))
  (put 'rest-terms 'spare (lambda (terms) (rest-terms terms)))
  (put 'make-term 'spare (lambda (order coeff) (make-term order coeff)))
  (put 'add-terms 'spare (lambda (l1 l2) (add-spare-terms l1 l2)))
  (put 'mul-terms 'spare (lambda (l1 l2) (mul-spare-terms l1 l2)))
  (put 'mul-term-by-all-terms 'spare (lambda (t l) (mul-spare-term-by-all-terms t l)))
  (put 'convert-to-density 'spare (lambda (terms) (convert terms)))
)

(define (make-polynomial var terms)
 ((get 'make 'polynomial) var terms))

(define (empty-termlist? l) (or (null? l) (null? (car l))))
(define (the-empty-termlist) '())

;only used in spare
(define (make-term order coeff) ((get 'make-term 'spare) order coeff))

(define (add-terms l1 l2)
  (cond ((empty-termlist? l1) l2)
        ((empty-termlist? l2) l1)
        ((number? (car l1))
          (cond ((number? (car l2)) ((get 'add-terms 'density) l1 l2))
                ((pair? (car l2)) ((get 'add-terms 'density)) l1 ((get 'convert-to-density 'spare) l2))
                (else (error "Unknown type l2: " l2))))
        ((pair? (car l1))
          (cond ((number? (car l2)) ((get 'add-terms 'density)) ((get 'convert-to-density 'spare) l1) l2)
                ((pair? (car l2)) ((get 'add-terms 'spare) l1 l2))
                (else (error "Unknown type l2: " l2))))
        (else (error "Unknown type l1: " l1))
  )
)

(define (mul-terms l1 l2)
  (cond ((or (empty-termlist? l1) (empty-termlist? l2)) (the-empty-termlist))
        ((number? (car l1))
          (cond ((number? (car l2)) ((get 'mul-terms 'density) l1 l2))
                ((pair? (car l2)) ((get 'mul-terms 'density) l1 ((get 'convert-to-density 'spare) l2)))
                (else (error "Unknown type l2: " l2))))
        ((pair? (car l1))
          (cond ((number? (car l2)) ((get 'mul-terms 'density)) ((get 'convert-to-density 'spare) l1) l2)
                ((pair? (car l2)) ((get 'mul-terms 'spare) l1 l2))
                (else (error "Unknown type l2: " l2))))
        (else (error "Unknown type l1: " l1))
  )
)

;test case:
(install-scheme-number-package)
(install-polynomial-package)
(install-spare-term-list-package)
(install-density-term-list-package)

(define p1 (make-polynomial 'x (list (make-term 2 4) (make-term 1 3) (make-term 0 10))))
(define p2 (make-polynomial 'x (list (make-term 1 2) (make-term 0 20))))
(define p3 (make-polynomial 'x (list 4 3 10)))
(define p4 (make-polynomial 'x (list 2 20)))

;(add p1 p2) ;(polynomial x (2 4) (1 5) (0 30))
;(mul p1 p2) ;(polynomial x (3 8) (2 86) (1 80) (0 200))
;(add p3 p4) ;(polynomial x (4 5 30))
;(mul p3 p4) ;(polynomial x (8 86 80 200))
