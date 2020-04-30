(load "util.scm")

(define (tree-map proc t)
  (map (lambda (x) (if (pair? x) (tree-map proc x) (proc x))) t))

(define (square-tree tree) (tree-map square tree))

(square-tree tree-test-1)
