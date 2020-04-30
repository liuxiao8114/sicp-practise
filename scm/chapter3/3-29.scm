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

; 2018/1/21 recoding
(define (or-gate-re a1 a2 output)
  (let ((invert-a1-output (make-wire))
        (invert-a2-output (make-wire))
        (and-output (make-wire)))
        (inverter a1 invert-a1-output)
        (inverter a2 invert-a2-output)
        (and-gate invert-a1-output invert-a2-output and-output)
        (inverter and-output output)
        'ok
  )
)

;a + b = ^(^a * ^b)
