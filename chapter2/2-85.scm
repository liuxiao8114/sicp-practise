(load "2-5-1.scm")

(put 'subtype 'complex drop-complex)
(put 'subtype 'rational drop-rational)

(define (drop-complex x)
  (if (equ? (imag x) 0)
    (make-rational (real x))
    (error "cannot drop: " x)
  )
)

(define (raise-rational x)
  (make-complex-from-real-imag x 0))

(define (drop x)
  ())
