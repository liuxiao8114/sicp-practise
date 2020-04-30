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
;2017/12/27 区别在于:
;(successive-merge-a (adjoin-set-huff new-sub-tree remain-tree))))
; 先合并,再重新生成新的顺序,再取最小两个生成新树
;(adjoin-set-huff new-sub-tree (successive-merge-b remain-tree))))
; 先继续取当前的最小两个生成新树,再重新排序
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
