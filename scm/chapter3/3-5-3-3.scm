(define (integral integrand initial-value dt)
  (define int (cons-stream initial-value (add-streams (scale integrand dt) int)))
  int
)

;;2019/03 rewrite
(define (integral integrand initial-value dt)
  (cons-stream inital-value (add-stream (scale-stream integrand dt) int))
)

;;3-73
(define (RC r c dt)
  (lambda (i-stream initial-v)
    (add-stream
      (scale-stream i-stream R)
      (integral (scale-stream i-stream (/ 1 c)) initial-v dt)
    )
  )
)

;;3-74
(define (sign-change-detector cur prev)
  (cond ((and (< 0 prev) (not (< 0 cur))) 1)
        ((and (< 0 cur) (not (< 0 prev))) -1)
        (else 0)
  )
)

(define (make-zero-crossings input-stream last-value)
  (cons-stream
    (sign-change-detector (stream-car input-stream) last-value)
    (make-zero-crossings (stream-cdr input-stream) (stream-car input-stream))
  )
)

(define zero-crossings (make-zero-crossings sensor-data 0))

(define zero-crossings
  (stream-map sign-change-detector sensor-data (cons-stream 0 sensor-data))
)

;;3-75
(define (make-zero-crossings input-stream last-value)
  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
    (cons-stream
      (sign-change-detector avpt last-value)
      (make-zero-crossings (stream-cdr input-stream) avpt)
    )
  )
)

(define (make-zero-crossings input-stream last-value last-avpt)
  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
    (cons-stream
      (sign-change-detector avpt last-avpt)
      (make-zero-crossings (stream-cdr input-stream) (stream-car input-stream) avpt)
    )
  )
)

;;3-76
(define (average a b) (/ (+ a b) 2))
(define (average-smooth a factor) (average a factor))

(define (last-value-stream initial-value stream)
  (cons-stream initial-value stream))

(define (smooth-stream stream smooth-method)
  (stream-map smooth-method stream (last-value-stream 0 stream))
)

(define (make-zero-crossings input-stream)
  (define sms (smooth-stream input-stream average-smooth))
  (stream-map
    sign-change-detector
    sms
    (last-value-stream (stream-car input-stream) sms)
  )
)

;; mote-calo
(define rand
  (let ((x random-init))
    (lambda () (set! x (random-update x)) x)
  )
)

(define (test) (= 1 (gcd (rand) (rand))))

(define (monte-cario trials experiment)
  (define (iter passed remain)
    (cond ((= remain 0) (/ passed trials))
          ((experiment) (iter (+ 1 passed) (- remain 1)))
          (else (iter passed (- remain 1)))
    )
  )
  (iter 0 trials)
)

(define rand-stream
  (cons-stream random-init (stream-map random-update rand-stream))
)

(define test-stream
  (define (inner-stream s)
    (cons-stream
      (stream-car s) (stream-car (stream-cdr s))
      (inner-stream (stream-cdr (stream-cdr s)))
    )
  )
  (inner-stream rand-stream)
)

(define )
