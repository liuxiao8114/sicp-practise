(load "util.scm")

;作为树考虑-->书里的解法
(define (sum-odd-squares t)
  (cond ((null? t) 0)
        ((pair? t) (+ (sum-odd-squares (car t)) (sum-odd-squares (cdr t))))
        (else (if (odd? t) (square t) 0))
  )
)

;作为序列考虑-->麻烦好多
(define (sum-odd-squares-2 t)
  (cond ((null? t) 0)
        ((pair? (car t)) (+ (sum-odd-squares-2 (car t)) (sum-odd-squares-2 (cdr t))))
        (else
          (if (odd? (car t))
            (+ (square (car t)) (sum-odd-squares-2 (cdr t)))
            (sum-odd-squares-2 (cdr t))
          )
        )
  )
)

(define (even-fibs n)
  (define (iter k ret)
    (if (= k n)
      ret
      (let ((f (fib k)))
        (if (even? f)
          (iter (+ k 1) (cons f ret))
          (iter (+ k 1) ret)
        )
      )
    )
  )
  (iter 0 '())
)

;(sum-odd-squares-2 tree-test-2)

;; Sequence Operations
;枚举 -> 过滤 -> 映射 -> 累加

(define (accumulate op initial seq)
  (if (null? seq)
    initial
    (op (car seq) (accumulate op initial (cdr seq)))
  )
)

(define (filter predicate seq)
  (cond ((null? seq) '())
        ((predicate (car seq)) (cons (car seq) (filter predicate (cdr seq))))
        (else (filter predicate (cdr seq)))
  )
)

(define (enum n)
  (define (iter r n)
    (if (= 0 n)
      r
      (iter (cons n r) (- n 1))
    )
  )
  (iter '() n)
)

(define (enum-interval low high)
  (if (> low high)
    '()
    (cons low (enum-interval (+ low 1) high))
  )
)

(define (enum-tree tree) ;this is the same as exec.2-28(fringe)
  (cond ((null? tree) '())
        ((not (pair? tree)) (list tree))
        (else append (enum-tree (car tree)) (enum-tree (cdr tree)))
  )
)
;(enum-tree '(1 (2 (3 4)) 5))
;(append (enum-tree 1) (enum-tree '((2 (3 4)) 5)))
;(append '(1) (append (enum-tree '(2 (3 4)) (enum-tree '(5)))))
;(append '(1) (append (enum-tree '(2 (3 4)) (append (enum-tree 5) (enum-tree '())))))
;(append '(1) (append (enum-tree '(2 (3 4)) '(5))))
;(append '(1) (append (append (enum-tree 2) (enum-tree '((3 4)))) '(5)))
;(append '(1) (append (append '(2) (append (enum-tree (3 4)) '())) '(5)))
;(append '(1) (append (append '(2) (append '(3 4) '(5)))))
;(append '(1) (append (append '(2) '(3 4 5))))

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

;通用过程:
(define (sum-odd-squares-comm tree)
  (accumulate + 0 (map square (filter odd? (enum-tree tree)))))

(define (enum-fib n)
  (define (iter k)
    (if (< k n)
      (cons (fib k) (iter (+ k 1)))
      '()
    )
  )
)

(define (enum-fib-re n)
  (map fib (enum-interval 0 n)))

(define (even-fibs-comm n)
  (accumulate cons '() (filter even? (enum-fib n))))

(define (list-fib-squares n)
  (accumulate
    cons '() (map square (map fib (enum-interval 0 n)))))

(define (product-of-squares-of-odd-elements sequence)
  (accumulate * 1 (map square (filter odd? sequence))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map
    make-pair-sum
    (filter
      prime-sum?
      (flatmap
        (lambda (x) (map (lambda (y) (list x y)) (enum (- x 1))))
        (enum n)
      )
    )
  )
)

;(prime-sum-pairs 10)
