(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right) (list entry left right))

(define (tree-list tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
      result-list
      (copy-to-list
        (left-branch tree)
        (cons (entry tree) (copy-to-list (right-branch tree) result-list))
      )
    )
  )
  (copy-to-list tree '())
)

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

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((> (car set1) (car set2)) (intersection-set set1 (cdr set2)))
        ((< (car set1) (car set2)) (intersection-set (cdr set1) set2))
        (else (cons (car set1) (intersection-set (cdr set1) (cdr set2))))
  )
)

;17/12/22 not work!
;如何找两个BST中相等的值? N*logN
(define (intersection-tree s1 s2)
  (let ((t1 (list-tree s1))
        (t2 (list-tree s2)))
    (define (iter a b ret)
      (cond ((= (entry a) (entry b)) (iter (cdr a) (cdr b) (cons (entry a) ret))
            ((< (entry a) (entry b)) (iter a (left-branch b)) ret)
            (else (iter a (right-branch b) ret)))
      )
    )
    (iter t1 t2 '())
  )
)
