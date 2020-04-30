(define one (cons-stream 1 one))
(define (add-stream s1 s2) (stream-map (lambda (x y) (+ x y)) s1 s2))
(define integers (cons-stream 1 (add-stream one integers)))

(define (partial-stream s)
  (define p (cons-stream 0 (add-stream p s)))
  p
)

(define (natural-logarithm-summands n)
  (cons-stream (/ 1.0 n) (stream-map - (natural-logarithm-summands (+ n 1))))
)

(define natural-logarithm-2
  (partial-stream (natural-logarithm-summands 1)))

(define natural-logarithm-summands-another
  (stream-map (lambda (x) (if (odd? x) (/ 1.0 x) (/ -1.0 x))) integers))

(define natural-logarithm-2-another
  (partial-stream natural-logarithm-summands-another))

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

;a
(display-stream natural-logarithm-2-another)

(define (euler-transform s)
  (let ((s0 (stream-ref s 0))
        (s1 (stream-ref s 1))
        (s2 (stream-ref s 2)))
    (cons-stream
      (- s2 (/ (square (- s2 s1)) (+ s0 (* -2 s1) s2)))
      (euler-transform (stream-cdr s))
    )
  )
)

;b
(display-stream (euler-transform natural-logarithm-2-another))

(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s)))

;c
(display-stream (accelerated-sequence euler-transform natural-logarithm-2-another))
