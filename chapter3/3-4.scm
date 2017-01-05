(define (make-account balance pass)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount)) balance)
      "Insufficient funds"))

  (define (deposit amount)
     (set! balance (+ balance amount)) balance)

  (define (call-the-cops msg)
    (list msg))

  (define incorrect-count 0)

  (define (dispatch input-pass m)
    (cond ((not (eq? input-pass pass))
            (if (not (< 2 incorrect-count))
              (call-the-cops input-pass)
              (begin (set! incorrect-count (+ 1 incorrect-count)) (error "Incorrect password"))))
          ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "UNKNOWN REQUEST -- MAKE_ACCOUNT" m))
    )
  )

  dispatch
)

(define acc (make-account 100 'secret-password))

;((acc 'secret-password 'withdraw) 40)
((acc 'some-other-password 'withdraw) 50)
