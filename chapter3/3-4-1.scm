(define balance 100)

(define (withdraw amount)
  (if (< balance amount)
    (error "no enough money " balance)
    (begin (set! balance (- balance amount)) balance)
  )
)

;Peter
(withdraw 10)

;Paul
(withdraw 25)

;the root of this complexity lies in the assignments to variables
;that are shared among the different process
;balance: 100
;(- balance 10): 90
;(set balance): 90
;balance: 90
;(- balance 25) 65
;(set balance): 65


;balance: 100
;balance: 100
;(- balance 10): 90
;(set balance): 90
;(- balance 25) 75
;(set balance): 75

;balance: 100
;balance: 100
;(- balance 25) 75
;(- balance 10): 90
;(set balance): 75
;(set balance): 90
