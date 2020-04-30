(load "2-2-3.scm")

(define (safe? k positions)
  (define (iter index pos)
    (cond ((null? pos) true)
          ((or
            (= (car positions) (car pos))
            (= (abs (/ (- k index) (- (car positions) (car pos)))) 1)) false)
          (else (iter (- index 1) (cdr pos)))
    )
  )
  (iter (- k 1) (cdr positions))
)

(define empty-board '())

(define (adjoin-position new-row size current-list)
  (cons new-row current-list))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (new-row)
            (map (lambda (rest-of-queens)
                   (adjoin-position new-row k rest-of-queens))
                 (queen-cols (- k 1))))
          (enum-interval 1 board-size)))))
  (queen-cols board-size)
)

(queens 4)

;run slowly的原因是,(queen-cols (- k 1))在嵌套map内执行,
;对(enum-interval 1 board-size))的每一个元素都要执行一次(queen-cols (- k 1)),
;并对(queen-cols (- k 1))的元素再执行map(adjoin-position过程可忽略不计)
;而每一个(queen-cols (- k 1))的调用又要递归调用(k - 1)次的(queen-cols (- k 2))
;和(queen-cols (- k 2))的元素数量相应的map
;当k = 6时((queen-cols 5) = 8 , (queen-cols 4) = 2) 相当于
;k * (k - 1) * 8
;k * (k - 1) * 8 * (k - 2) * 2 * (k - 3) * (k - 4)...
;6! * 8 * 2
