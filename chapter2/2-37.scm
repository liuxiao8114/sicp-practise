(load "2-36.scm")

(define (transpose m)
  (accumulate-n cons '() m))

(transpose tree-test-3)
