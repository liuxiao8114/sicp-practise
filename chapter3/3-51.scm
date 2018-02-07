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
  (steam-map show (force (stream-enumerate-interval 1 10)))
)

(stream-ref x 5)
;output: 1
(stream-ref (stream-cdr x) 4)
;output: 2
(stream-ref (stream-cdr (stream-cdr x)) 3)
;output: 3
...
(stream-ref (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr x))))) 0)
;output: 5

(stream-ref x 7)
