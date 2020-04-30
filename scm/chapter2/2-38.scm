(load "2-2-3.scm")

(define fold-right accumulate)

(define (fold-left op init seq)
  (define (iter result rest)
    (if (null? rest)
      result
      (iter (op result (car rest)) (cdr rest))
    )
  )
  (iter init seq)
)

;(/ 1 (/ 2 (/ 3 1)))
;(fold-right / 1 (list 1 2 3))

;(/ (/ (/ 1 1) 2) 3)
;(fold-left / 1 (list 1 2 3))

;(list 1 (list 2 (list 3 '())))
;(fold-right list '() (list 1 2 3))

;(list (list (list '() 1) 2) 3)
;(fold-left list '() (list 1 2 3))

;不强调顺序性，即满足交换律。x op y  === y op x
;同运算下可以结合，满足结合律。 (a op b) op c === a op (b op c)
