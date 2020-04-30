(define (make-frame-1 o e1 e2)
  (list o e1 e2))

(define (make-frame-2 o e1 e2)
  (cons o (cons e1 e2)))

(define (origin-frame f)
  (car f))

(define (edge1-frame f)
  (cadr f))

(define (edge2-frame f)
  (caddr f))
