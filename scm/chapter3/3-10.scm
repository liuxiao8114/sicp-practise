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
  ((lambda (balance)
    (lambda (amount)
      (if(> balance amount)
        (begin (set! balance (- balance amount)) balance)
        "Insufficient funds"
      )
    ))
    initial-amount
  )
)

(define w1 (make-withdraw 100))

;((lambda (<var>) (<body>)) <exp>) <=> (let ((<exp> <var>)) <body>)
;用initial-amount代替原来直接的balance参数，然后在过程里面再定义局部变量balacne，赋值等于initial-amount
;实际等于多一层的函数调用，多了一层上下文
