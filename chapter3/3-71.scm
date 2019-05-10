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

;;; 2019
(define (merge-weight s1 s2 weight)
  ()
)

(define (pairs s1 s2 weight-method)
  (cons-stream
    (list (stream-car s1) (stream-car s2))
    (merge-weight
      (stream-map (lambda (x) (* x (stream-car s1))) (stream-cdr s2))
      (pairs (stream-cdr s1) (stream-cdr s2))
      weight-method
    )
  )
)

(define (cube-weight x) (+ (cube (car x) (cube (cadr x)))))
(define cube-pairs (pairs integers integers cube-weight))
(define (iter-stream s1 s2)
  (let (l1 (stream-car s1))
       (l2 (stream-car s2))
    (if (= (cube-weight l1) (cube-weight l2))
      (cons-stream (iter-stream (stream-cdr s1) (stream-cdr s2)))
      (iter-stream (stream-cdr s1) (stream-cdr s2))
    )
  )
)

(define ramanujan-numbers (iter cube-pairs (stream-cdr cube-pairs)))

(define (stream-map proc .streams)
  (cons-stream
    (apply proc (map stream-car streams))
    (apply stream-map (cons proc (map stream-cdr streams)))
  )
)

(define (stream-filter fn .streams)
  (cond ((stream-null? (stream-car streams)) the-empty-stream)
        ((apply fn (map stream-car streams))
          (cons-stream
            ()
            (apply stream-filter (cons fn (map stream-cdr streams)))
          )
        )
        (else (apply stream-filter (cons fn (map stream-cdr streams)))))

  )
)
