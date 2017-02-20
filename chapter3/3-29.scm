(load "3-3-4.scm")

(define (logical-or a1 a2)
  (cond ((and (number0 a1) (number0 a2)) 0)
        ((or (number1 a1) (number1 a2)) 1)
        (else (error "Invalid signal -- " s))
  )
)

(define (or-gate a1 a2 output)
  (inverter (and-gate (inverter a1 output) (inverver a2 output) output) output)
)

;a + b = ^(^a * ^b)
