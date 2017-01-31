(define (quotient x n)
  ())

(define (list-tree elements)
  (car (partial-tree elements (length elements))))


(define (partial-tree e n)
  (if (= n 0)
    (cons '() e)
    (let ((left-size (quotient (- n 1) 2)))
      (let ((left-result (partial-tree e left-size)))
        (let ((left-tree (car left-result))
              (non-left-e (cdr left-result))
              (right-size (- (- n left-size) 1)))
          (let ((entry (car non-left-e))
                (right-result (partial-tree (cdr non-left-e) right-size)))
            (let ((right-tree (car right-result))
                  (remain-e (cdr right-result)))
              (cons (make-tree entry left-result right-result) remain-e)
            )
          )
        )
      )
    )
  )
)

;1.取总长度的(n - 1) / 2 至左子树
;2.递归求左子树
;3.取剩余元素和剩余长度，求根结点
;4.由剩余元素和剩余长度,递归求右子树
;5.
