(load "2-28.scm")
(load "2-38.scm")

(define (reverse-r seq)
  (fold-right (lambda (x y) (cons y x)) '() seq)
)

(define (reverse-l seq)
  (fold-left (lambda (x y) ()) '() seq)
)

(reverse-r tree-test-2)
