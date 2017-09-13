(define (sprt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.0001)
  )

  (define (improve guess)
    (average guess (/ x guess)))

  (define (sqrt-iter guess)
    (if (good-enought? guess)
        guess
        (sqrt-iter (improve guess))
    )
  )

  (sqrt-iter 1.0)
)

(sprt 10)
----------------------------
|全局:
|  sqrt                   |
|  参数:x                 |
|  过程:(sqrt-iter 1.0)   |
|                         |
----------------------------
  ^
  |
  |
----------------------------
| E1 10           |
| good-enough?    |
| improve         |
| sqrt-iter       |
-------------------

(sqrt-iter 1.0)
