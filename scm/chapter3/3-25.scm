;2018/01/19 旧的实现版本与这次实现的区别在于local-table的结构不同
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

(define (assoc-re key-list records)
  (cond ((null? records) false)
        ((equal-list? key-list (caar records)) (car records))
        (else (assoc-re key-list (cdr records)))
  )
)

(define (equal-list? l1 l2) 
  (define (iter x y) 
    (cond ((and (null? x) (null? y)) true)
          ((eq? (car x) (car y)) (iter (cdr x) (cdr y)))
          (else false)
    )
  )
  (if (eq? (length l1) (length l2))
    (iter l1 l2)
    false
  )
)

(define (make-table-re) 
  (let ((local-table (list '*table*)))
    (define (lookup key-list) 
      (let ((result (assoc-re key-list (cdr local-table))))
        (if result
          (cdr result)
          false
        )
      )
    )
    
    (define (insert! key-list value) 
      (let ((result (assoc-re key-list (cdr local-table))))
        (if result
          (set-cdr! value result)
          (set-cdr! local-table (cons (cons key-list value) (cdr local-table)))
        )
      )
    )
    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc) insert!)
            ((eq? m 'local-table) local-table)
            (else (error "Unknown operation -- TABLE: " m))
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

(define operation-table-re (make-table-re))
(define get-re (operation-table-re 'lookup-proc))
(define put-re (operation-table-re 'insert-proc))

(put-re (list 'a 'b 'c) 11)
(put-re (list 'a 'b) (cons 'd 12))