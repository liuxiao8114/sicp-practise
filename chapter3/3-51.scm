(define (stream-enumerate-interval low high)
  (if (> low high)
    the-empty-stream
    (cons-stream
      low
      (stream-enumerate-interval (+ low 1) high)
    )
  )
)

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
  (display x))

(define (show x)
  (display-line x)
  x
)

(define x (stream-map show (stream-enumerate-interval 0 10)))

;(stream-enumerate-interval 0 10) <=> (cons-stream 0 (stream-enumerate-interval 1 10))
;init x
;output: 0
(stream-map show (cons-stream 0 (stream-enumerate-interval 1 10)))
(cons-stream
  (show 0)
  (stream-map show (stream-cdr (cons-stream 0 (stream-enumerate-interval 1 10))))
) <=>
(cons-stream
  (show 0)
  (stream-map show (force (delay (stream-enumerate-interval 1 10))))
)

(stream-ref x 5)
;output: 0
(stream-ref (stream-cdr x) 4) <=>
(stream-ref
  (force (stream-map show (stream-cdr (cons-stream 0 (stream-enumerate-interval 1 10)))))
  4
) <=>
(stream-ref
  (force (delay (stream-map show (force (delay (stream-enumerate-interval 1 10))))))
  4
)

;output: 1
(stream-ref (stream-cdr (stream-cdr x)) 3)
;output: 2
...
(stream-ref (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr x))))) 0)
;output: 4

(stream-ref x 7)
