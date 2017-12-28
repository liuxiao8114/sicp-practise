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

;1.取总长度的(n - 1) / 2 作为左子树的长度
;2.递归生成左子树
;3.从剩余元素和剩余长度取根结点(car)
;4.由剩余元素和剩余长度,递归生成右子树
;5.组合根,左子树,右子树
