;3.1.2 The Benefits of Introducing Assignment
(load "util.scm")

(define random-init (+ 1 (random 9999)))
(define (random-update x) (+ 1 (random 9999)))

(define rand
  (let ((x random-init))
    (lambda () (set! x (random-update x)) x)
  )
)

;入口(模拟结果处理)
(define (estimate-pi trials)
  (sqrt (/ 6 (monte-cario trials cesaro-test))))

;实验方法
(define (cesaro-test)
  (= 1 (gcd (rand) (rand))))

;蒙特卡罗模拟定义
(define (monte-cario trials experiment)
  (define (iter trials-remain trials-passed)
    (cond ((= 0 trials-remain) (/ trials-passed trials))
          ((experiment) (iter (- trials-remain 1) (+ trials-passed 1)))
          (else (iter (- trials-remain 1) trials-passed))
    )
  )
  (iter trials 0)
)

;非赋值的实验方法
(define (random-gcd-test trials initial-x)
  (define (iter trials-remain trials-passed x)
    (let ((x1 (random-update x)))
      (let ((x2 (random-update x1)))
        (cond ((= 0 trials-remain) (/ trials-passed trials))
              ((= 1 (gcd x2 x1)) (iter (- trials-remain 1) (+ trials-passed 1) x2))
              (else (iter (- trials-remain 1) trials-passed x2))
        )
      )
    )
  )
  (iter trials 0 initial-x)
)

;调用
;(estimate-pi 10000)
;(sqrt (/ 6 (random-gcd-test 10000 0)))
; 0 is the initial number which can be every numbers. as the book mentioned:
; Even the top-level procedure estimate-pi
; has to be concerned with supplying an initial random number
