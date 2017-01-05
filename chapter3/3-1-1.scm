(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount)) balance)
      "Insufficient funds"))
  (define (deposit amount)
     (set! balance (+ balance amount)) balance)

  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else  (error "UNKNOWN REQUEST -- MAKE_ACCOUNT" m))
    )
  )
  dispatch
)

(define acc (make-account 100))

((acc 'withdraw) 50)
