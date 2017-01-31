(define tree-test-1 (list 1 (list 2 (list 3 4 5))))
(define tree-test-2 (list 1 2 3 4 5))
(define tree-test-3 (list (list 1 2 3 4) (list 4 5 6 6) (list  6 7 8 9)))

(define (inc x) (+ x 1))
(define (square x) (* x x))
(define (cube x) (* x x x))

(define (average a b)
  (/ (+ a b) 2))

(define (width a b)
  (if(> a b)
    (/ (- a b) 2)
    (/ (- b a) 2)))

(define (odd? n)
  (= (remainder n 2) 1))

(define (even? n)
  (= (remainder n 2) 0))

(define (muti x n)
  (cond ((= n 0) 1)
        ((= n 1) x)
        ((even? n) (muti (square x) (/ n 2)))
        (else (* x (muti x (- n 1))))
  )
)

(define (smallest-divisor n)
  (find-divisor n 2))

(define (divides? a b)
  (= (remainder a b) 0))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? n test-divisor) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (prime? n)
  (= (smallest-divisor n) n))

(define tolerance 0.00001)

(define (fix-point f first-guess)
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess (f guess))
        guess
        (try next)
      )
    )
  )
  (try first-guess)
)

(define (sqrt x)
  (fix-point (average-damp (lambda y (/x y))) 1.0))

(define (append list1 list2)
  (if (null? list1)
    list2
    (cons (car list1) (append (cdr list1) list2))))

;fib 2 = fib 1 + fib 0
;fib 3 = fib 2 + fib 1
;fib 4 = fib 3 + fib 2
(define (fib k)
  (if (or (= k 0) (= k 1))
    1
    (+ (fib (- k 1) (fib (- k 2))))
  ))

(define (fib-improve k)
  (define (fib-iter a b n)
    (if (> n k)
      b
      (fib-iter (+ a b) a (+ n 1))))
  (fib-iter 1 1 1)
)


;; from 3.3, used in 2-4

(define (equal? a b)
  (cond ((and (pair? a) (pair? b))
          (if (eq? (car a) (car b))
            (equal? (cdr a) (cdr b))
            false
          )
        )
        ((or (pair? a) (pair? b)) false)
        ((eq? a b) true)
        (else false)
  )
)

(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))
  )
)

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
          (let ((record (assoc key-2 (cdr subtable))))
            (if record
              (cdr record)
              false
            )
          )
          false
        )
      )
    )
    (define (insert key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
          (let ((record (assoc key-2 (cdr subtable))))
            (if record
              (set-cdr! record value)
              (set-cdr! subtable (cons (cons key-2 value) (cdr subtable)))
            )
          )
          (set-cdr! local-table (cons (list key-1 (cons key-2 value)) (cdr local-table)))
        )
      )
    )
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert)
            (else (error "Unknown operation -- TABLE" m))
      )
    )
    dispatch
  )
)

(define operation-table (make-table)) ;<-- warn: this is diff from (define operation-table make-table)
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))
