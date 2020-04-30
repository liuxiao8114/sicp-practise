(define (make-withdraw balance)
  (lambda (amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount)) balance)
      "Insufficient funds"
    )
  )
)

(define w1 (make-withdraw 100))

(w1 50)



-----------------------------------
全局       w1     make-withdraw
过程参数 balance     balance
