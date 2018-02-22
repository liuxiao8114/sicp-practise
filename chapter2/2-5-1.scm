(load "2-4-3.scm") ;引入install-rect-package 和 install-imag-package

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (equ? x y) (apply-generic 'equ? x y)) ;practise2.79
(define (=zero? x) (apply-generic '=zero? x)) ;practise2.80

(define (install-scheme-number-package)
  (define (tag x) (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number) (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number) (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number) (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number) (lambda (x y) (tag (/ x y))))
  (put 'equ? '(scheme-number scheme-number) (lambda (x y) (= x y)))  ;practise2.79
  (put '=zero? '(scheme-number) (lambda (x) (= x 0)))  ;practise2.80
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
  'done
)

(define (make-rational n d)
  ((get 'make 'rational) n d))

(define (install-complex-package)
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rect) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))

  (define (tag z) (attach-tag 'complex z))
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2)) (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2)) (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2)) (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2)) (- (angle z1) (angle z2))))

  (define (equ?-complex z1 z2)
    (and
      (= (real-part z1) (real-part z2))
      (= (imag-part z1) (imag-part z2)))
  )

  (define (=zero?-complex z)
    (and
      (= (real-part z) 0)
      (= (imag-part z) 0))
  )

  (put 'add '(complex complex) (lambda (z1 z2) (tag (add-comlex z1 z2))))
  (put 'sub '(complex complex) (lambda (z1 z2) (tag (sub-comlex z1 z2))))
  (put 'mul '(complex complex) (lambda (z1 z2) (tag (mul-comlex z1 z2))))
  (put 'div '(complex complex) (lambda (z1 z2) (tag (div-comlex z1 z2))))

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

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang x y)
  ((get 'make-from-mag-ang 'complex) x y))
