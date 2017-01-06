(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))
  )
)

(define (monte-cario trials experiment)
  (define (iter trials-remain trials-passed)
    (cond ((= 0 trials-remain) (/ trials-passed trials))
          ((experiment) (iter (- trials-remain 1) (+ trials-passed 1)))
          (else (iter (- trials-remain 1) trials-passed))
    )
  )
  (iter trials 0)
)

(define (rect-grand x1 x2 y1 y2)
  (* (- x2 x1) (- y2 y1)))

(define (p x y)
  (not (< 9 (square (- x 5)) (square (- y 7))))
)

(define (estimate-integral p x1 x2 y1 y2 count)
  (define round-test
    (let ((randx (random-in-range x1 x2))
          (randy (random-in-range y1 y2)))
      (p randx randy)
    )
  )
  (/ (rect-grand x1 x2 y1 y2) (monte-cario count round-test))
)

(estimate-integral p 2 8 4 10 100)
