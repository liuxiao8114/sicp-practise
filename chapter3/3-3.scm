(define (make-account balance pass)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount)) balance)
      "Insufficient funds"))
  (define (deposit amount)
     (set! balance (+ balance amount)) balance)

  (define (dispatch input-pass m)
    (cond ((not (eq? input-pass pass)) "Incorrect password")
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

(define (make-account balance pass)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount)) balance)
      "Insufficient funds"))
  (define (deposit amount)
     (set! balance (+ balance amount)) balance)

  (define (dispatch input-pass m)
    ((lambda (count) (
      (cond ((not (eq? input-pass pass)) "Incorrect password")
            ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            (else (error "UNKNOWN REQUEST -- MAKE_ACCOUNT" m))
      )
    )) 0)
  )
  dispatch
)
