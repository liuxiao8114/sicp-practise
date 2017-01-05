(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))
  )
)

(define (monte-carlo count experiment))

(define (grand x1 x2 y1 y2)
  (* (- x2 x1) (- y2 y1)))

(define (round-test p x1 y1)
  (let ((randx (random-in-range (car x1) (car y1)))
        (randy (random-in-range (cadr x1) (cadr y1))))
    (p randx randy)
  )
)

(define (estimate-integral p x1 x2 y1 y2 count)
  (/ (grand x1 x2 y1 y2) (monte-carlo count (round-test p))))

(define (p x y x1 y1)
  ())
