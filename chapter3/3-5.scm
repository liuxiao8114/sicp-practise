(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random (exact->inexact range)))
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

;(define (rect-grand x1 x2 y1 y2)
;  (* (- x2 x1) (- y2 y1)))

(define (p x y)
  (not (< 9 (+ (square (- x 5)) (square (- y 7)))))
)

(define (estimate-integral p x1 x2 y1 y2 count)
  (define (round-test)
    (let ((randx (random-in-range x1 x2))
          (randy (random-in-range y1 y2)))
      (p randx randy)
    )
  )
  ;注意题目所选取的两个点(2,4), (8,10)恰是该圆的外切正方形，而正方形的面积是其内切圆的4倍
  (* 4 (exact->inexact (monte-cario count round-test)))
)

(estimate-integral p 2 8 4 10 10000)


;--------2017/09/07 re?
(define (p x y)
  (not (< 1.0 (+ (square x) (square y))))
)

(define (calculate-pi p x1 x2 y1 y2 count)
  (define (estimate-integral)
    (p (random-in-range x1 x2) (random-in-range y1 y2)))

  (* (exact->inexact (monte-cario count estimate-integral)) 4)
)

(calculate-pi p -1.0 1.0 -1.0 1.0 10000)

;(define (test exp) (cond ((eq? #t exp) 'yes!) (else 'no!)))
;(test (not (> 1 0)))

;(> 3 2)
;(p (random-in-range -1.0 1.0) (random-in-range -1.0 1.0))
