(define (make-account balance)
  (define (withdraw amount) ())

  (define (deposit amount) ())

  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "UNKNOWN request -- " m))
    )
  )
  dispatch
)

(define acc1 (make-account 100))

------------------
global::
make-account
      ^
      |
------------------
      |
------------------
parm: balance = 100
process: dispatch
------------------

------------------
E1::
withdraw
deposit
dispatch
------------------

;共享make-account的环境
((acc1 'deposit) 40)
------------
acc1
------------

((acc1 'withdraw) 20)

;acc1与acc2共享全局环境
(define acc2 (make-account 200))
------------------
E2::
withdraw
deposit
dispatch
------------------
