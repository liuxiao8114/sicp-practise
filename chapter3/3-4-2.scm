;3.4.2 Mechanisms for Controlling Concurrency

;A more practial approach to the design of concurrent systems is
;to devise general mechanisms that allow us to constrain the interleaving of concurrent processes
;so that we can be sure the program behavior is correct

(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (protected withdraw))
            ((eq? m 'deposit) (protected deposit))
            ((eq? m 'balance) balance)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch)
)

;;Complexity of using multiple shared resources

(define (exchange account1 account2)
  (let ((diff (- (balance account1) (balance account2))))
    ((account1 'withdraw) diff)
    ((account2 'deposit) diff)
  )
)

(define (make-account-and-serializer balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch)
)

(define (deposit account amount)
  (let ((s (account 'serializer)))
        (d (account 'deposit))
    ((s d) amount)
  )
)

(define (serialized-exchange account1 account2)
  (let ((s1 (account 'serializer))
        (s2 (account 'serializer)))
    ((s1 (s2 exchange)) account1 account2)
  )
)

;;Implementing serializers

(define (make-serializer)
  (let ((m (make-mutex)))
    (lambda (p)
      (define (serialize-p . args)
        (m 'acquire)
        (let ((val (apply p args)))
          (m 'release)
          val
        )
      )
      serialize-p
    )
  )
)

(define (make-mutex)
  (let ((cell (list false)))
    (define (acquire)
      (if (test-and-set! cell)
        (me 'acquire)
      )
    )

    (define (clear!)
      (set-car! cell false)
    )

    (define (me request)
      (cond ((eq? request 'acquire) (acquire))
            ((eq? request 'release) (clear!))
            (else (error "Unknown request -- " request))
      )
    )
    me
  )
)

(define (test-and-set! cell)
  (if (car cell)
      true
      (begin (set-car! cell true)
             false)))

(define balance 100)

(define a (make-account balance))
(define b (make-account balance))

((a 'withdraw) 10)
((a 'deposit) 20)
