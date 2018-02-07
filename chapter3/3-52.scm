(define (display-stream s)
  (stream-for-each display-line s))

(define sum 0)

(define (accum x)
  (set! sum (+ x sum))
  sum)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))
(define y (stream-filter even? seq))
;index(1 2 3 4  5  6  7  8  9  10 11 12 13 14  15  16  17  18  19  20)
;seq: (1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136 153 171 190 210)
;e3  y6
;e4  y10
;e7  y28
;e8  y36
;e11 y66
;e12 y78
;e15 y120
(define z (stream-filter
            (lambda (x) (= (remainder x 5) 0))
            seq))

(stream-ref y 7)
(display-stream z)

1. value of sum:
(define seq ...)   sum = 1      seq: (cons-stream 1 (stream-map...))
(define y ...)     sum = 6      seq: (cons-stream 1 (cons-stream 3 ...) y: (cons-stream 6 (stream-filter...))
(define z ...)     sum = 10     z: (cons-stream 10 (stream-filter...))
(stream-ref y 7)   sum = 120
(display-stream z) sum = 210

;几点注意：
;stream-ref 和stream-for-each(由display-stream调用)并不会产生延迟求值(没有cons-stream的调用)
;延迟求值发生在stream-filter,即y和z的定义当中
; y的第一个值为6(stream-car y) (stream-car z)为10
;当调用(stream-ref y 7)时, 对y的stream-filter调用yield在sum = 120
;而接着调用(display-stream z)时, z当中的第二个元素15,是memo-proc的结果
;(即(stream-enumerate-interval 5 20))已经执行过了
