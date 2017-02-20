(define (assoc key records f)
  (cond ((null? records) false)
        ((f key (caar records) (car records)))
        (else (assoc key (cdr records) f))
  )
)

(define (make-table f)
  (let ((local-table '*table*))
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
      ()
    )

    (define (dispatch m)
      (cond ((eq? m 'lookup) lookup)
            ((eq? m 'insert) insert)
            (else error "No Method -- " m)
      )
    )
  )
)

(define balance 1)

(define (same-key? a b)
  (if (and (number? a) (number? b))
    (> balance (abs (- a b)))
    (equal? a b)
  )
)

(define t (make-table same-key?))

((t insert) )
