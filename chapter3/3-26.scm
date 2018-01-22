(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))
  )
)

(define (make-table)
  (let ((key '())
       (value '())
       (left-branch '())
       (right-branch '()))
    (let ((local-table (list key value left-branch right-branch)))
      (define (tree-key) key)
      (define (tree-value) value)
      (define (tree-left-branch) left-branch)
      (define (tree-right-branch) right-branch)

      (define (empty? t) (null? key))

      (define (set-key! new-key) (set! key new-key))
      (define (set-value! new-value) (set! value new-value))
      (define (set-left-branch! new-left) (set! left-branch new-left))
      (define (set-right-branch! new-right) (set! right-branch new-right))

      (define (insert! given-key given-value compare)
        (define (insert-iter t)
          (if ((t empty?))
            (begin
              ((t 'set-key!) given-key)
              ((t 'set-value!) given-value)
              (set-left-branch! t (make-table))
              (set-right-branch! t (make-table)))
            (let ((compare-result (compare given-key (t 'key))))
              (cond ((= 0 compare-result) (t 'set-value))
                    ((= -1 compare-result) (insert! right-branch given-key given-value compare))
                    ((= 1 compare-result) (insert! left-branch given-key given-value compare))
              )
            )
          )
        )
        (insert-iter )
      )

      (define (lookup given-key compare)
        (if (empty?)
          false
          ()
        )
      )

      (define (dispatch m)
        (cond ((eq? m 'insert!) insert!)
              ((eq? m 'lookup) lookup)
              ((eq? m 'empty?) empty)
              ((eq? m 'key) tree-key)
              ((eq? m 'value) tree-value)
              ((eq? m 'left-branch) tree-left-branch)
              ((eq? m 'right-branch) tree-right-branch)
              ((eq? m 'set-key!) set-key!)
              ((eq? m 'set-value!) set-value!)
              ((eq? m 'set-left-branch!) set-left-branch!)
              ((eq? m 'set-right-branch!) set-right-branch!)
              (else error "No Method -- " m)
        )
      )
      dispatch
    )
  )
)

(define (assoc-re key tree-records compare-to)
  (cond ((null? tree-records) false)
        ((= (compare-to key (caar records))) (car records))
        ((< (compare-to key (caar records))) (assoc-re key (cadr records) compare-to))  ;left-branch
        (else (assoc-re key (caddr records) compare-to)) ;right-branch
  )
)

(define (assoc-re-insert key tree-records compare-to value)
  (cond ((null? tree-records) (make-tree key value '() '()))
        ((= (compare-to key (caar records))) (set-cdr! (car records) value))
        ((< (compare-to key (caar records))) (assoc-re-insert key (cadr records) compare-to value))  ;left-branch
        (else (assoc-re-insert key (caddr records) compare-to value)) ;right-branch
  )
)

(define (make-tree key value left right) 
  (list (cons key value) left right)
)

(define (make-table-re)
  (let ((local-table (list '*table)))      
    (define (lookup key) 
      (let ((record (assoc-re key tree-records compare-to)))
        (if record
          (cdr record)
          false
        )  
      )
    )
      
    (define (insert! key value) 
      (let ((record (assoc-re key tree-records compare-to)))
        (if record
          (set-cdr! record value)
          ()
        )
      )
    )
      
    (define (dispatch m) 
      (cond ((eq? m 'lookup) lookup)
            ((eq? m 'insert!) insert!)
      )
    )
    dispatch
  )
)
