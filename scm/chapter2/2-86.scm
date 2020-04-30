(define (install-complex-package)
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rect) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'pola) r a))

  (define (tag z) (attach-tag 'complex z))
  (define (add-complex z1 z2)
    (make-from-real-imag (add (real-part z1) (real-part z2)) (add (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (sub (real-part z1) (real-part z2)) (sub (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (mul (magnitude z1) (magnitude z2)) (add (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (div (magnitude z1) (magnitude z2)) (sub (angle z1) (angle z2))))

  (define (equ?-complex z1 z2)
    (and
      (equ? (real-part z1) (real-part z2))
      (equ? (imag-part z1) (imag-part z2)))
  )

  (define (=zero?-complex z)
    (and
      (equ? (real-part z) 0)
      (equ? (imag-part z) 0))
  )

  (put 'add '(complex complex) (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex) (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex) (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex) (lambda (z1 z2) (tag (div-complex z1 z2))))

  ;practise2.79 & 2.80
  (put 'equ? '(complex complex) (lambda (z1 z2) (equ?-complex z1 z2)))
  (put '=zero? '(complex) (lambda (z) (=zero?-complex z)))
  (put 'make-from-real-imag 'complex (lambda (real imag) (tag (make-from-real-imag real imag))))
  (put 'make-from-mag-ang 'complex (lambda (mag ang) (tag (make-from-mag-ang mag ang))))

  ;for practise2.77
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude '(complex) magnitude)
  (put 'angle '(complex) angle)

  'done
)
