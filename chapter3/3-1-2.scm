(load "util.scm")

(define random-init (random 10000))
(define (random-update x) (random 10000))

(define rand
  (let ((x random-init))
    (lambda ()
      (if (= x 0)
        ()
        (set! x (random-update x))) x)
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

;调用
(estimate-pi 10000)
