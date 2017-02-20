(define (call-each p)
  (if (null? p)
    'done
    (begin (car p) (call-each (cdr p)))
  )
)

(define (make-wire)
  (let ((signal-value 0) (action-proc '()))
    (define (set-signal! new-value)
      (if (not (= signal-value new-value))
        (begin (set! signal-value new-value)
          (call-each action-proc)
          'done
        )
      )
    )
    (define (accept-action-proc! proc)
      (set! action-proc (cons proc action-proc))
      (proc)
    )
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
            ((eq? m 'set-signal!) set-signal!)
            ((eq? m 'add-action!) accept-action-proc!)
            (else error "Unknown oeration -- WIRE " m)
      )
    )
    dispatch
  )
)

(define (get-signal wire)
  (wire 'get-signal))

(define (set-signal wire new-value) ((wire 'set-signal!) new-value))

(define (add-action wire proc) ((wire 'add-action!) proc))

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
