(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))
  )
)

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-list)
      (define (iter l result)
        (if (null? l)
          (cdr result)
          (let ((subtable (assoc (car l) (cdr result))))
            (if subtable
              (iter (cdr l) subtable)
              false
            )
          )
        )
      )
      (iter key-list local-table)
    )

    (define (insert! key-list value)
      (define (list-iter items)
        (if (null? (cdr items))
          (cons (car items) value)
          (list (car items) (list-iter (cdr items)))
        )
      )

      (define (iter l result)
        (if (null? l)
          (if (null? (cdr result))
            (set-cdr! result value)
            (set-cdr! result (cons value (cdr result)))
          )

          (let ((subtable (assoc (car l) (cdr result))))
            (if subtable
              (iter (cdr l) subtable)
              (set-cdr! result (cons (list-iter l) (cdr result)))
            )
          )
        )
      )
      (iter key-list local-table)
    )

    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc) insert!)
            (else (error "Unknown operation -- TABLE" m))
      )
    )
    dispatch
  )
)

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc))

(put (list 'a 'b 'c) 1)
;(list '*table* (list 'a (list 'b (cons 'c 1))))
(put (list 'a 'b) (cons 'd 2))
;(list '*table* (list 'a (list 'b (cons 'd 2) (cons 'c 1))))
