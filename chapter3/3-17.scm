(define (memq? x list)
  (cond ((null? list) #f)
    ((eq? x (car list)) #t)
    (else (memq? x (cdr list)))
  )
)

(define (count-pairs-self x)
  (define (iter e l)
    (cond ((not (pair? e)) l)
          ((memq? (car e) l) (iter (cdr e) l))
          (else (iter (cdr e) (iter (car e) (cons (car e) l))))
    )
  )

  (iter x '())
)

;(count-pairs-self (list one one 2))
;(iter (list one one 2) '())
;(iter (list one 2) (iter one (cons one '())))
;(iter (list one 2) (iter one (list one)))


(define (inner x list)
  (if (and (pair? x) (not (memq? x list)))
    (inner (car x) (inner (cdr x) (cons x list)))
    list
  )
)

(define (count-pairs x)
  (inner x '()))

(define one (list 1))

(define three (cons one one))

(define seven (cons three three))

;(count-pairs-self three)
;(inner one (inner one (cons three '())))
;(inner one (cons one (cons three '())))
;(cons one (cons three '()))
;<=>(list one three)
;2

(count-pairs (list one one 2))
;(inner one (inner (list one 2) (cons (list one one 2) '())))
;(inner one (inner one (inner (list 2) (cons (list one 2) (cons (list one one 2) '())))))
;(inner one (inner one (inner 2 (inner '() (cons (list 2) (cons (list one 2) (cons (list one one 2) '())))))))
;(inner one (inner one (cons (list 2) (cons (list one 2) (cons (list one one 2) '())))))
;(inner one (cons one (cons (list 2) (cons (list one 2) (cons (list one one 2) '())))))
;(cons one (cons (list 2) (cons (list one 2) (cons (list one one 2) '()))))
;<=>(list one (list 2) (list one 2) (list one one 2))
;4
