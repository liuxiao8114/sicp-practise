(define (new-cons a b)
  (if (predicate-cons)
    (cons a b)
    (let ((c (b)))
      (cons a c)
    )
  )
)

(define predicate-cons
  (let ((flag false))
    (begin
      (cons (set! flag false) (set! flag true))
      flag
    )
  )
)
