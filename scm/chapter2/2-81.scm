(load "util.scm")

(define (scheme-number->scheme-number n) n)
(define (complex->complex z) z)

(put-coercion 'scheme-number 'scheme-number
              scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)

;a) 死循环。由于没有定义complex的exp的过程,以下过程将死循环:
;(apply-generic op (t1-t2 a1) a2)) <-其中(t1-t2 a1) <=> a1
;(apply-generic op a1 a2)
;(get op type-tags) no defination
;(apply-generic op (t1-t2 a1) a2))

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
                (cond ((t1-t2) (apply-generic op (t1-t2 a1) a2))
                      ((t2-t1) (apply-generic op a1 (t2-t1 a2)))
                      (else (error "No method for these tags" (list op type-tags)))
                )
              )
            )
          )
          (error "No method")
        )
      )
    )
  )
)
