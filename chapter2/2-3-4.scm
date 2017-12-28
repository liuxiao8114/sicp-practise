;叶子构造函数，选择函数（叶值，叶权重）make-leaf symbol-leaf weight-leaf
;判断叶子 leaf?
;生成huff树 make-code-tree
;左分支和右分支 left-b right-b
;权重和值 weight symbol
;解构值 decode
;初始符号权重序列 make-leaf-set

(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list
    left
    right
    (append (symbols left) (symbols right))
    (+ (weight left) (weight right))
  )
)

(define (left-b tree) (car tree))
(define (right-b tree) (cadr tree))

(define (symbols tree)
  (cond ((null? tree) '())
        ((leaf? tree) (list (symbol-leaf tree)))
        (else (caddr tree))
  )
)

(define (weight tree)
  (cond ((null? tree) 0)
        ((leaf? tree) (weight-leaf tree))
        (else (cadddr tree))

  )
)

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
      '()
      (let ((next-branch
              (choose-branch (car bits) current-branch)))
        (if (leaf? next-branch)
          (cons (symbol-leaf next-branch) (decode-1 (cdr bits) tree))
          (decode-1 (cdr bits) next-branch)
        )
      )
    )
  )
  (decode-1 bits tree)
)

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-b branch))
        ((= bit 1) (right-b branch))
        (else (error "bad bit"))
  )
)

(define (adjoin-set-huff x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set) (adjoin-set-huff x (cdr set))))
  )
)

(define (make-leaf-set pairs)
  (if (null? pairs)
    '()
    (let ((pair (car pairs)))
      (adjoin-set-huff
        (make-leaf (car pair) (cadr pair))
        (make-leaf-set (cdr pairs))
      )
    )
  )
)

(make-leaf-set '((c 1) (d 1) ((e f g) 10) (b 2) (a 4))) ; error!
(make-leaf-set '((c 1) (d 1) (e 10) (b 2) (a 4))) ; OK!
