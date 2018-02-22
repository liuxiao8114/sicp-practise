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
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enum-interval 1 board-size))
          )
          (queen-cols (- k 1))))))
  (queen-cols board-size))

(queens 5)
