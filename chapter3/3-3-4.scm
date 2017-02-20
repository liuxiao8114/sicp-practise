(define (get-signal wire)
  ())

(define (set-signal wire) ())

(define (add-action wire proc) ())

(define (after-delay delay proc) ())

(define (logical-not s)
  (cond ((= s 1) 0)
        ((= s 0) 1)
        (else (error "Invalid signal -- " s))
  )
)

(define (inverter input output)
  (define (invert-input)
    (let ((new-value (logical-not (get-signal input))))
      (after-delay
        inverter-delay
        (lambda () (set-signal output new-value))
      )
    )
  )
  (add-action input invert-input)
)

(define (number0? num)
  (and (number? num) (= 0 num)))

(define (number1? num)
  (and (number? num) (= 1 num)))

(define (logical-and a1 a2)
  (cond ((or (number0 a1) (number0 a2)) 0)
        ((and (number1 a1) (number1 a2)) 1)
        (else (error "Invalid signal -- " s))
  )
)

(define (and-gate a1 a2 output)
  (define (and-input)
    (let ((new-value (logical-and (get-signal a1) (get-signal a2))))
      (after-delay and-delay (lambda () (set-signal output new-value)))
    )
  )
  (add-action a1 and-input)
  (add-action a2 and-input)
)
