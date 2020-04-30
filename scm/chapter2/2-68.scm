(load "2-3-4.scm")

(define tree (make-code-tree (make-leaf 'a 4)
                (make-code-tree (make-leaf 'b 2)
                  (make-code-tree (make-leaf 'd 1) (make-leaf 'c 1))
                )
  )
)

(define tree2 (make-code-tree (make-leaf 'a 4) (make-leaf 'b 2)))

(define (encode-symbol c tree)
  (cond ((null? tree) '())
        ((leaf? tree) (if (eq? c (symbol-leaf tree)) '() (error "no this char!")))
        ((eq? c (car (symbols (left-b tree)))) (cons 0 '()))
        (else (cons 1 (encode-symbol c (right-b tree))))
  )
)

;2017/12/27 encode-symbol 在下面的测试虽然能通过，但这个实现是有问题的.
;原因是huffman-tree的实现中,左树不一定是leaf
;如果上面的 tree的定义,修改 a 的值为 5(使 a > b + c + d), 调用make-code-tree后
;((leaf 'b (...) (b d c) 6)  (leaf 'a) (b d c a) 9)

(define (encode-symbol-a c tree)
  (cond ((leaf? tree) '())
        ((symbol-in-tree? c (left-b tree)) (cons 0 (encode-symbol-a c (left-b tree))))
        ((symbol-in-tree? c (right-b tree)) (cons 1 (encode-symbol-a c (right-b tree))))
        (else (error "can not find c in the given tree. c: " c))
  )
)

(define (symbol-in-tree? c tree)
  (not (false? (find (lambda (s) (eq? c s)) (symbols tree)))
  )
)

(define (encode msg tree)
  (if (null? msg)
    '()
    (append (encode-symbol-a (car msg) tree)
      (encode (cdr msg) tree))
  )
)

;(symbols (left-b (right-b tree2)))

(encode '(a d a b b c a) tree)
;(encode '(b) tree2)
