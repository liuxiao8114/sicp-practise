(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 0.5 1 2 5 10 20 100 50))

(define (no-more? l)
  (null? l))

(define (except-first-denomination l) (cdr l))

(define (first-denomination l) (car l))

(define (cc amount coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coins)) 0)
        (else
          (+ (cc amount (except-first-denomination coins))
             (cc (- amount (first-denomination coins)) coins))
        )
  )
)

(cc 100 us-coins)
