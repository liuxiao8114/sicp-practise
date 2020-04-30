(define (mystery x)
  (define (loop x y)
    (if (null? x)
      y
      (let ((temp (cdr x)))
        (begin (set-cdr! x y) (loop temp x))
      )
    )
  )
  (loop x '())
)

(define v (list 'a 'b 'c 'd))

(define w (mystery v))

;v ---> a | b c d ---> b | c d ---> c | d ---> d | nil

;x ---> a | b c d ---> b | c d ---> c | d ---> d | nil
;             |
;             nil

;temp1 ---> b | c d
;                |
;                a | nil

;temp2 ---> c | d
;               |
;               b | a
