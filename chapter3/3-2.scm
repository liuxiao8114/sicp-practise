(load "util.scm")

(define (make-monitored f)
  (define (mf count)
    (define (proc m)
      (cond ((eq? m 'how-many-calls?) count)
            ((eq? m 'reset-count) (begin (set! count 0) count))
            (else (begin (set! count (+ 1 count)) (f m)))
      )
    )
    proc
  )
  (mf 0)
)

(define s (make-monitored square))

(s 10)
