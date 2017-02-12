
(define acc1 (make-account 100))
;共享make-account的环境
((acc 'deposit) 40)
((acc 'withdraw) 20)

;acc1与acc2共享全局环境
(define acc2 (make-account 200))
