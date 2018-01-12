(load "2-5-1.scm")

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

(define (install-polynomial-package)
  (define (make-poly variable term-list)
    (cons variable term-list))

  (define (variable p) (car p))
  (define (term-list p) (cdr p))

  (put 'add '(polynomial polynomial) (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial) (lambda (p1 p2) (tag (mul-poly p1 p2))))
)

(define (empty-termlist? l) (null? (car l)))

(define (the-empty-termlist) '())

(define (make-term order coeff)
  (cons order coeff))

(define (first-term l)
  (map order l))

(define (rest-terms l)
  ())

(define (order t) (car t))

(define (coeff t) (cdr t))

(define (adjoin-term t l) ())

(define (add-terms l1 l2)
  (cond ((empty-termlist? l1) l2)
        ((empty-termlist? l2) l1)
        (else
          (let ((t1 (first-term l1)) (t2 (first-term l2)))
            (cond ((< (order t1) (order t2)) (adjoin-term (add-terms l1 (rest-terms l2))))
                  ((> (order t1) (order t2)) (adjoin-term (add-terms (rest-terms l1) l2)))
                  (else (adjoin-term
                          (add (coeff t1) (coeff t2))
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
    (make-poly (mul t1))
  )
)
