(load "util.scm")
(load "2-2-3.scm")

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
    '()
    (cons (accumulate op init (map (lambda (x) (car x)) seqs))
      (accumulate-n op init (map (lambda (x) (cdr x)) seqs))
    )
  )
)

(accumulate-n + 0 tree-test-3)
