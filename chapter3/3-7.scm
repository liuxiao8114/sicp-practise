(define (make-account balance pass)
  (let ((shared-pass 'null))

    (define (withdraw amount)
      (if (>= balance amount)
        (begin (set! balance (- balance amount)) balance)
        "Insufficient funds"))

    (define (deposit amount)
      (set! balance (+ balance amount)) balance)

    (define (set-shared-pass m)
      (set! shared-pass m) shared-pass)

    (define (dispatch input-pass m)
      (cond ((not (or (eq? input-pass pass) (eq? input-pass shared-pass))) "Incorrect password")
            ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            ((eq? m 'set-shared-pass) set-shared-pass)
            (else (error "UNKNOWN REQUEST -- MAKE_ACCOUNT" m))
      )
    )

    dispatch
  )
)

(define (make-joint account pass new-pass)
  ((account '123 'set-shared-pass) new-pass)
  account
)

(define lei-acc (make-account 100 '123))

(define xiao-acc (make-joint lei-acc '123 '1234))

((xiao-acc '1234 'withdraw) 50)
