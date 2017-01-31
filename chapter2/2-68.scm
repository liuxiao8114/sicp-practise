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

(define (encode msg tree)
  (if (null? msg)
    '()
    (append (encode-symbol (car msg) tree)
      (encode (cdr msg) tree))
  )
)

;(symbols (left-b (right-b tree2)))

(encode '(a d a b b c a) tree)
;(encode '(b) tree2)
