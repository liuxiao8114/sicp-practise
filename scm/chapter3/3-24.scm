(define (assoc key records f)
  (cond ((null? records) false)
        ((f key (caar records)) (car records))
        (else (assoc key (cdr records) f))
  )
)

(define (make-table f)
  (let ((local-table (list '*table*)))
    (define (lookup key1 key2)
      (let ((subtable (assoc key1 (cdr local-table) f)))
        (if subtable
          (let ((record (assoc key2 (cdr subtable) f)))
            (if record
              (cdr record)
              false
            )
          )
          false
        )
      )
    )

    (define (insert key1 key2 value)
      (let ((subtable (assoc key1 (cdr local-table) f)))
        (if subtable
          (let ((record (assoc key2 (cdr subtable) f)))
            (if record
              (set-cdr! record value)
              (set-cdr! subtable (cons (cons key2 value) (cdr subtable)))
            )
          )
          (set-cdr! local-table (cons (list key1 (cons key2 value)) (cdr local-table)))
        )
      )
    )

    (define (dispatch m)
      (cond ((eq? m 'lookup) lookup)
            ((eq? m 'insert) insert)
            (else error "No Method -- " m)
      )
    )
    dispatch
  )
)

(define balance 10)

(define (same-key? a b)
  (if (and (number? a) (number? b))
    (> balance (abs (- a b)))
    (equal? a b)
  )
)

(define t (make-table same-key?))

;test case
((t 'insert) 'A 1 'a)
((t 'insert) 'B 11 'b)
((t 'insert) 'C 21 'c)
((t 'insert) 'B 31 'b)
((t 'lookup) 'B 35)
