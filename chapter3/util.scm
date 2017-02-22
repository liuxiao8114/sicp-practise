(define (inc x) (+ x 1))
(define (square x) (* x x))
(define (cube x) (* x x x))

(define (number0? num)
  (and (number? num) (= 0 num)))

(define (number1? num)
  (and (number? num) (= 1 num)))

(define (average a b)
  (/ (+ a b) 2))

(define (width a b)
  (if(> a b)
    (/ (- a b) 2)
    (/ (- b a) 2)))

(define (odd? n)
  (= (remainder n 2) 1))

(define (even? n)
  (= (remainder n 2) 0))

(define (muti x n)
  (cond ((= n 0) 1)
        ((= n 1) x)
        ((even? n) (muti (square x) (/ n 2)))
        (else (* x (muti x (- n 1))))
  )
)

(define (smallest-divisor n)
  (find-divisor n 2))

(define (divides? a b)
  (= (remainder a b) 0))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? n test-divisor) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (prime? n)
  (= (smallest-divisor n) n))

(define tolerance 0.00001)

(define (close-enough? a b)
  (> tolerance (abs (- a b))))

(define (average-damp f)
  (lambda (x) (average x (f x)))
)

(define (fix-point f first-guess)
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess (f guess))
        guess
        (try next)
      )
    )
  )
  (try first-guess)
)

(define (sqrt x)
  (fix-point (average-damp (lambda (y) (/ x y))) 1.0))

(define (append list1 list2)
  (if (null? list1)
    list2
    (cons (car list1) (append (cdr list1) list2))))

;fib 2 = fib 1 + fib 0
;fib 3 = fib 2 + fib 1
;fib 4 = fib 3 + fib 2
(define (fib k)
  (if (or (= k 0) (= k 1))
    1
    (+ (fib (- k 1) (fib (- k 2))))
  ))

(define (fib-improve k)
  (define (fib-iter a b n)
    (if (> n k)
      b
      (fib-iter (+ a b) a (+ n 1))))
  (fib-iter 1 1 1)
)

(define (gcd a b)
  (cond ((< a b) (gcd b a))
        ((= 0 (remainder a b)) b)
        (else (gcd b (remainder a b)))
  )
)
