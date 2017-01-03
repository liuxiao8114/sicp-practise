(define (start-point point)
  (car point))

(define (end-point point)
  (cdr point))

(define (make-point x y)
  (cons x y))

(define (make-segment pointX pointY)
  (cons pointX pointY))

(define (start-segment segment)
  (car segment))

(define (end-segment segment)
  (cdr segment))

(define (print-point p)
  (newline)
  (display "(")
  (display (start-point p))
  (display ",")
  (display (end-point p))
  (display ")")
)

(define (average a b)
  (/ (+ a b) 2))

(define (midpoint-segment segment)
  (let ((s-point (start-segment segment))
        (e-point (end-segment segment)))
    (print-point
      (make-point
        (average (start-point s-point) (start-point e-point))
        (average (end-point s-point) (end-point e-point))
      )
    )
  )
)

(midpoint-segment (make-segment (make-point 5 6) (make-point 3 4)))
;(midpoint-segment 1 2 3 4)
