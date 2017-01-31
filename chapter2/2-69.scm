(load "2-3-4.scm")

(define (reverse l)
  (define (iter i result)
    (if (null? i)
      result
      (iter (cdr i) (cons (car i) result))
    )
  )
  (iter l '())
)

;wrong
(define (successive-merge tree)
  (define (iter t result)
    (if (null? t)
      result
      (iter
        (cdr t)
        (make-code-tree
          (make-code-tree
            (make-leaf 'leaf (car (car t)) (cdr (car t)))
            (make-leaf 'leaf (car (cadr t) (cdr (cadr t))))
          )
          result
        )
      )
    )
  )
  (iter (reverse tree) '())
)

(define (successive-merge-a tree)
  (cond ((= 0 (length tree)) '())
        ((= 1 (length tree)) (car tree))
        (else (let ((new-sub-tree (make-code-tree (car tree) (cadr tree)))
                  (remain-tree (cddr tree)))
              (successive-merge-a (adjoin-set-huff new-sub-tree remain-tree))))
  )
)

;why this doesn't work?
(define (successive-merge-b tree)
  (cond ((= 0 (length tree)) '())
        ((= 1 (length tree)) (car tree))
        (else (let ((new-sub-tree (make-code-tree (car tree) (cadr tree)))
                  (remain-tree (cddr tree)))
              (adjoin-set-huff new-sub-tree (successive-merge-b remain-tree)))) ;<---point!
  )
)

(define (generate-huffman-tree pairs)
  (successive-merge-a (make-leaf-set pairs)))

(generate-huffman-tree '((a 4) (b 2) (c 1) (d 1)))
