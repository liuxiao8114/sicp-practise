(load "util.scm")

(define (add-complex z1 z2)
  (make-from-real-imag (+ (real-part z1) (real-part z2))
    (+ (imag-part z1) (imag-part z2))
  )
)

(define (real-part-rect z) (car z))

(define (imag-part-rect z) (cadr z))

(define (magnitude-rect z)
  (sqrt (+ (square (real-part-rect z)) (square (imag-part-rect z)))))

(define (angle-rect z)
  (atan (imag-part-rect z) (real-part-rect z)))

(define (make-from-real-imag-rect x y) (cons x y))

(define (make-from-mag-ang-rect r a)
  (cons (* r (cos a)) (* r (sin a))))

(define (magnitude-pola z) (car z))
(define (angle-pola z) (cadr z))

(define (real-part-pola z) (* (magnitude-pola z) (cos (angle-pola z))))

(define (imag-part-pola z) (* (magnitude-pola z) (sin (angle-pola z))))

(define (make-from-real-imag-pola x y) (cons (sqrt (+ (square x) (square y))) (atan y x)))

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
    (car datum)
    (error "Bad tagged datum")
  )
)

(define (contents datum)
  (if (pair? datum)
    (cadr datum)
    (error "Bad contented datum")
  )
)

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc))

(define (install-rect-package)
  (define (real-part z) (car z))
  (define (imag-part z) (cadr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z)) (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))

  (define (tag x) (attach-tag 'rect x))
  (put 'real-part '(rect) real-part)
  (put 'imag-part '(rect) imag-part)
  (put 'magnitude '(rect) magnitude)
  (put 'angle '(rect) angle)
)

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (apply proc (map contents args))
        (error "No methods")
      )
    )
  )
)

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))

(define (make-from-real-imag x y)
  ((get 'make-from-real-imag 'rect) x y))

(define (make-from-mag-ang r a)
  ((get 'make-from-mag-ang 'pola) r a))
