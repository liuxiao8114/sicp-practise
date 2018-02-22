(load "2-5-1.scm")

(define (raise-scheme-number x)
  (make-rational x 1))

(define (raise-rational x)
  (make-complex-from-real-imag x 0))

(put 'supertype 'scheme-number raise-scheme-number) ;better to be added in package
(put 'supertype 'rational raise-rational) ;better to be added in package

(define (scheme-number-complex n)
  (make-complex-from-real-imag (contents n) 0))

(define (scheme-number-rational n)
  (make-rational n 1))

(put-coercion 'scheme-number 'rational scheme-number-rational)
(put-coercion 'scheme-number 'complex scheme-number-complex)

(define (raise x)
  (let ((proc (get 'supertype (type-tag x))))
    (if proc
      (proc (contents x))
      (error "no supertype for: " x)
    )
  )
)

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (apply proc (map contents args))
        (if (= 2 (length args))
          (let ((type1 (car type-tags))
                (type2 (cadr type-tags))
                (a1 (car args))
                (a2 (cadr args)))
            (if (eq? type1 type2)
              (error "No method (no coercion because of same type)")
              (let ((t1-t2 (get-coercion type1 type2))
                    (t2-t1 (get-coercion type2 type1)))
                (cond (t1-t2 (apply-generic op (t1-t2 a1) a2))
                      (t2-t1 (apply-generic op a1 (t2-t1 a2)))
                      (else (error "No method for these tags" (list op type-tags)))
                )
              )
            )
          )
          (error "No method (the number of args beyond three can't get coercion)")
        )
      )
    )
  )
)

;test case
(install-rational-package)
(install-scheme-number-package)
(add 3 (make-rational 1 3)) ;(list rational (cons 10 3))
