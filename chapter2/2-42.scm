(load "2-2-3.scm")

(define empty-board '())

(define (safe? length p)
  (let ((x (car p))
        (seq (cdr p)))
    (define (iter x y)
      (= x (car y) #f))
    (cond ((null? seq) ())
          (() ())
          (() ())
    )
  )
)

(define (adjoin-position a seq)
  (cons a seq))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
      (list empty-board)
      (filter
        (lambda (positions) (safe? k positions))
        (flatmap
          (lambda
            (rest-queens)
            (map
              (lambda (new-row) (adjoin-position new-row rest-queens))
              (enum board-size)
            )
          )
          (queen-cols (- k 1))
        )
      )
    )
  )
  (queen-cols board-size)
)

(queens 6)
