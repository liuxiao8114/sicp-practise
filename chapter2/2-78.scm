(load "2-5-1.scm")

(define (attach-tag tag contents)
  (if (number? contents)
    contents
    (cons tag contents)
  )
)

(define (type-tag datum)
;  (cond ((number? datum) datum) <-- wrong!
  (cond ((number? datum) 'scheme-number)
        ((pair? datum) (car datum))
        (else (error "Bad tagged datum"))
  )
)

(define (contents datum)
  (cond ((number? datum) datum)
        ((pair? datum) (car datum))
        (else (error "Bad contented datum"))
  )
)

(install-scheme-number-package)
;(make-scheme-number 3)
(add (make-scheme-number 3) (make-scheme-number 4))
