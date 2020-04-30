(define the-agenda (make-agenda))

(define (after-delay delay action)
  (add-to-agenda! (+ delay (current-time the-agenda)) action the-agenda)
)

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

(define (logical-and a1 a2)
  (cond ((or (number0? a1) (number0? a2)) 0)
        ((and (number1? a1) (number1? a2)) 1)
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

(define (logical-or a1 a2)
  (cond ((and (number0? a1) (number0? a2)) 0)
        ((or (number1? a1) (number1? a2)) 1)
        (else (error "Invalid signal -- " s))
  )
)

(define (or-gate a1 a2 output)
  (define (or-input)
    (let ((new-value (logical-or (get-signal a1) (get-signal a2))))
      (after-delay or-delay (lambda () (set-signal output new-value)))
    )
  )
  (add-action a1 or-input)
  (add-action a2 or-input)
)


(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok
  )
)

(define (full-adder a b c-in sum c-out)
  (let ((s1 (make-wire))
        (c1 (make-wire))
        (c2 (make-wire)))
    (half-adder b c-in s1 c1)
    (half-adder a s1 sum c2)
    (or-gate c1 c2 c-out)
    'ok
  )
)