(load "2-3-4.scm")

(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree (make-leaf 'B 2)
                    (make-code-tree (make-leaf 'D 1) (make-leaf 'C 1))
                  )
  )
)

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

(decode sample-message sample-tree)

(decode-1 s-m s-t)
(cons (s-l next-branch) (decode-1 (cdr s-m) s-t))
(cons (s-l (choose-branch 0 s-t)) (decode-1 (cdr s-m) s-t))
(cons (s-l (left-branch s-t)) (decode-1 (cdr s-m) s-t))
(cons (s-l (list 'leaf 'A 4)) (decode-1 (cdr s-m) s-t))
(cons 'A (decode-1 (cdr s-m) s-t))
(cons 'A (decode-1 (cdr (cdr s-m)) (right-b s-t)))
(cons 'A (decode-1 (cdr (cdr s-m)) (right-b s-t)))
