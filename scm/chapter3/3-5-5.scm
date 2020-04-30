;3.5.5 Modularity of Functional Programs and Modularity of Objects
(define (rand-update x) (+ 1 (random 9999)))
(define init-x 1)

(define rand-stream
  (cons-stream init-x (stream-map rand-update rand-stream)))

(define cesaro-stream
  (map-successive-pairs (lambda (x y) (= 1 (gcd x y))) rand-stream))

(define (map-successive-pairs f s)
  (cons-stream
    (f (stream-car s) (stream-car (stream-cdr s)))
    (map-successive-pairs f (stream-cdr s))
  )
)

(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
      (/ passed (+ passed failed))
      (monte-carlo (stream-cdr experiment-stream) passed failed)
    )
  )

  (if (stream-car experiment-stream)
    (next (+ passed 1) failed)
    (next passed (+ failed 1))
  )
)

(define pi (stream-map (lambda (p) (sqrt (/ 6 p))) (monte-carlo cesaro-stream 0 0)))

;;A functional-programming view of time
(define (stream-withdraw balance amount-stream)
  (cons-stream
    balance
    (stream-withdraw (- balance (stream-car amount-stream)) (stream-cdr amount-stresam))
  )
)
