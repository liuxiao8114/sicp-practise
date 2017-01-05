(load "util.scm")

(define random-init (random 10000))
(define (random-update x) (random 10000))

(define rand
  (let ((x random-init))
    (lambda () (set! x (random-update x)) x)
  )
)

(define (estimate-pi trials)
  (sqrt (/ 6 (monte-cario trials cesaro-test))))

(define (cesaro-test)
  (= 1 (gcd (rand) (rand))))

(define (monte-cario trials experiment)
  (define (iter trials-remain trials-passed)
    (cond ((= 0 trials-remain) (/ trials-passed trials))
          ((experiment) (iter (- trials-remain 1) (+ trials-passed 1)))
          (else (iter (- trials-remain 1) trials-passed))
    )
  )
  (iter trials 0)
)

(define (bad-test)
  (let ((x1) (random-update init))

  )
)
