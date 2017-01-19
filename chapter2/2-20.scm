(load "util.scm")

(define (same-parity a . l)
  (if (odd? a)
    (iter l odd?)
    (iter l even?)
  )
)

(define (iter l pat)
  (cond ((null? l) '())
        ((pat (car l)) (cons (car l) (iter (cdr l) pat)))
        (else (iter (cdr l) pat))
  )
)

(same-parity 1 2 3 4 5)
