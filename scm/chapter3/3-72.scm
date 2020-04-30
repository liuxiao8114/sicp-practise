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

(define (square-weight p)
  (+ (square (car p)) (square (cadr p))))

;;;可用KMP算法优化???
(define (iter-stream s)
  (let ((s0 (stream-car s))
        (s1 (stream-car (stream-cdr s)))
        (s2 (stream-car (stream-cdr (stream-cdr s))))
        (next-s (stream-cdr (stream-cdr s))))
    (if (and
          (= (square-weight s1) (square-weight s0))
          (= (square-weight s1) (square-weight s2)))
      (cons-stream (list s0 s1 s2 (square-weight s0)) (iter-stream next-s))
      (iter-stream next-s)
    )
  )
)

(define square-numbers-with-three-ways
  (iter-stream (weighted-pairs integers integers square-weight))
)

(define one (cons-stream 1 one))
(define integers (cons-stream 1 (add-stream one integers)))
