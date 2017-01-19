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
        ((pair? (car t)) (+ (sum-odd-squares (car t)) (sum-odd-squares (cdr t))))
        (else (if (odd? (car t)) (+ (square (car t)) (sum-odd-squares (cdr t))) (sum-odd-squares (cdr t))))
  )
)

;(sum-odd-squares-2 tree-test-2)

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

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

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
