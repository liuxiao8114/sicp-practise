;09/12
;第一次调用f,返回形参值
;reset f过程,使其无视调用参数,只返回0

(define re-f
  (lambda (x)
    (begin (set! re-f (lambda (y) 0)) x)
  )
)

;test
(+ (re-f 0) (re-f 1)) ;1
(+ (re-f 1) (re-f 0)) ;0
