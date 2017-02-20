(load "3-3-4.scm")

(define (logical-or a1 a2)
  (cond ((and (number0 a1) (number0 a2)) 0)
        ((or (number1 a1) (number1 a2)) 1)
        (else (error "Invalid signal -- " s))
  )
)

(define (or-gate a1 a2 output)
  (define (or-input)
    (let ((new-value (logical-or (get-signal a1) (get-signal a2))))
      (after  -delay or-delay (lambda () (set-signal output new-value)))
    )
  )
  (add-action a1 or-input)
  (add-action a2 or-input)
)
