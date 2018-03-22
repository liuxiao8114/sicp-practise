(define (merge-weighted s1 s2 weight)
  (let ((s1-car (stream-car s1))
        (s2-car (stream-car s2)))
    (let ((weight-s1-car (weight s1-car))
          (weight-s2-car (weight s2-car)))
      (cond ((< weight-s1-car weight-s2-car) (cons-stream s1-car (merge-weighted (stream-cdr s1) s2 weight)))
            ((> weight-s1-car weight-s2-car) (cons-stream s2-car (merge-weighted s1 (stream-cdr s2) weight)))
            (else
              (begin
                (newline)
                (display (list 'show3: s1-car s2-car weight-s1-car weight-s2-car))
                (cons-stream
                  s1-car
                  (cons-stream
                    s2-car
                    (merge-weighted (stream-cdr s1) (stream-cdr s2) weight)
                  )
                )
              )
            )
      )
    )
  )
)

(define (weighted-pairs s t weight)
  (cons-stream (list (stream-car s) (stream-car t))
    (merge-weighted
      (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
      (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
      weight
    )
  )
)

;for test case:
(define (cube x) (* x x x))
(define (stream-for-each-another proc s k n)
  (if (or (stream-null? s) (= k n))
    'done
    (begin
      (proc (stream-car s))
      (stream-for-each-another proc (stream-cdr s) (+ k 1) n)
    )
  )
)

(define (display-stream s)
  (stream-for-each-another display-line s 1 5))

(define (display-line x)
  (newline)
  (display x))

(define one (cons-stream 1 one))
(define (add-stream s1 s2) (stream-map + s1 s2))
(define integers (cons-stream 1 (add-stream one integers)))

(define (cube-weight p)
  (+ (cube (car p)) (cube (cadr p))))

(define stream-cube-weighted (weighted-pairs integers integers cube-weight))
(define comparator 0)
(define (stream-filter-another proc s)
  (if (proc (stream-car s))
    (begin
      (set! comparator (cube-weight (stream-car s)))
      (cons-stream (stream-car s) (stream-filter-another proc (stream-cdr s)))
    )
    (begin
      (set! comparator (cube-weight (stream-car s)))
      (stream-filter-another proc (stream-cdr s))
    )
  )
)

(define ramanujan-numbers
  (stream-filter-another (lambda (x) (= comparator (cube-weight x))) stream-cube-weighted))

(define (iter-stream s)
  (let ((s0 (cube-weight (stream-car s)))
        (s1 (cube-weight (stream-car (stream-cdr s))))
        (s2 (cube-weight (stream-car (stream-cdr (stream-cdr s)))))
        (next-s (stream-cdr (stream-cdr (stream-cdr s)))))
    (if (or (= s1 s0) (= s1 s2))
      (cons-stream (list s1) (iter-stream next-s))
      (iter-stream next-s)
    )
  )
)

;从display结果来看这个方法的运行速度要比上一个慢
(define ramanujan-numbers-b
  (iter-stream stream-cube-weighted)
)

(display-stream ramanujan-numbers-b)
