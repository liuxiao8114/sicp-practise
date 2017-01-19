(load "util.scm")
(load "2-2-3.scm")

(define (map p seq)
  (accumulate (lambda (x y) (cons (p x) y)) '() seq))

;(map square tree-test-2)

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

(define (length seq)
  (accumulate (lambda (x y) (+ 1 y)) 0 seq))

(length (list 1 2 3 4))
