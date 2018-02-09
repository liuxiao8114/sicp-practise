(load "util.scm")
(define (s-q l)
  (define (i l result)
    (if(null? l)
      result
      (i (cdr l) (cons result (square (car l))))
    )
  )
  (i l '())
)

(s-q (list 1 2 3))
;(0 1)
;((0 1) 4)
;(((0 1) 4) 9)

;2018/02/08 attention:the result won't be a list like above,
;it is just a pair in which car is another pair constructed last time. 
;(cons '() 1)
;(cons (cons '() 1) 4)
;(cons (cons (cons '() 1) 4) 9)
;display: (((nil . 1) . 4) . 9)
