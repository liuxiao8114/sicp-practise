(define (merge s1 s2)
  (let ((s1-car (stream-car s1))
        (s2-car (stream-car s2)))
    (cond ((< s1-car s2-car) (cons-stream s1-car (merge (stream-cdr s1) s2)))
          ((> s1-car s2-car) (cons-stream s2-car (merge s1 (stream-cdr s2))))
          (else (cons-stream s1-car (merge (stream-cdr s1) (stream-cdr s2))))
    )
  )
)

(define (merge-weighted s1 s2 weight)
  (let ((s1-car (stream-car s1))
        (s2-car (stream-car s2)))
    (let ((weight-s1-car (weight s1-car))
          (weight-s2-car (weight s2-car)))
      (cond ((< weight-s1-car weight-s2-car)
              (begin
                (newline)
                (display (list 'show1: s1-car s2-car))
                (cons-stream s1-car (merge-weighted (stream-cdr s1) s2 weight))
              )
            )
            ((> weight-s1-car weight-s2-car)
              (begin
                (newline)
                (display (list 'show2: s1-car s2-car))
                (cons-stream s2-car (merge-weighted s1 (stream-cdr s2) weight))
              )
            )
            (else
              (begin
                (newline)
                (display (list 'show3: s1-car s2-car))
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
  (stream-for-each-another display-line s 1 10))

(define (display-line x)
  (newline)
  (display x))

(define one (cons-stream 1 one))
(define (add-stream s1 s2) (stream-map + s1 s2))
(define integers (cons-stream 1 (add-stream one integers)))

;a
(define (a-weight p)
  (+ (car p) (cadr p)))

(define stream-a (weighted-pairs integers integers a-weight))

(display-stream stream-a)
