(load "util.scm")
(load "3-3-4-1.scm") ;defined wire
(load "3-3-4-2.scm") ;defined agenda
(load "3-3-4-3.scm") ;defined varies of gates

(define (propagate)
  (if (empty-agenda? the-agenda)
    'done
    (let ((first-item (frist-agenda-item the-agenda)))
      (first-item)
      (remove-first-agenda-item! the-agenda)
      (propagate)
    )
  )
)

(define (probe name wire)
  (add-action
    wire
    (lambda ()
      (newline)
      (display name)
      (display "  ")
      (display (current-time the-agenda))
      (display " New-Value = ")
      (display (get-signal wire))
    )
  )
)

;test case

(define inverter-delay 2)
(define and-delay 3)
(define or-delay 5)

(define input-1 (make-wire))
(define input-2 (make-wire))
(define sum (make-wire))
(define carry (make-wire))

;(probe 'sum sum)
;(probe 'carry carry)

;(half-adder input-1 input-2 sum carry)

;(set-signal input-1 1)

;(propagate)
