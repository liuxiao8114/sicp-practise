(load "2-3-4.scm")

(define (encode-symbol c tree)
  (cond ((leaf? tree) '())
        ((symbol-in-tree? c (left-b tree)) (cons 0 (encode-symbol c (left-b tree))))
        ((symbol-in-tree? c (right-b tree)) (cons 1 (encode-symbol c (right-b tree))))
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
    (append (encode-symbol (car msg) tree)
      (encode (cdr msg) tree))
  )
)

(define (successive-merge tree)
  (cond ((= 0 (length tree)) '())
        ((= 1 (length tree)) (car tree))
        (else (let ((new-sub-tree (make-code-tree (car tree) (cadr tree)))
                   (remain-tree (cddr tree)))
              (successive-merge (adjoin-set-huff new-sub-tree remain-tree))))
  )
)

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define song '((a 2) (na 16) (boom 1) (sha 3) (get 2) (yip 9) (job 2) (wah 1)))
;(define song '((a 2) (na 16) (boom 1) (sha 3)))
(define msg
  '(Get a job Sha na na na na na na na na Get a job Sha na na na na na na na na Wah yip yip yip yip yip yip yip yip yip Sha boom))

(define tree (generate-huffman-tree song))
(define msg-1 '(Get a job))

(encode msg-1 tree)
;(encode msg (generate-huffman-tree song))
