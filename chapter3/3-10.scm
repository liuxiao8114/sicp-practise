(define (make-withdraw initial-amount)
  (let ((balance initial-amount))
    (lambda (amount)
      (if(> balance amount)
        (begin (set! balance (- balance amount)) balance)
        "Insufficient funds"
      )
    )
  )
)

(define (make-withdraw initial-amount)
  (lambda (balance)
    (lambda (amount)
        (if(> balance amount)
          (begin (set! balance (- balance amount)) balance)
          "Insufficient funds"
        )
      ) initial-amount)
)

(define w1 (make-withdraw 100))

;全局 make-withdraw w1
;w1 initial-amount
;匿名 balance
