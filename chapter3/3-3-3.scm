(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records) (car records)))
        (else (assoc key (cdr records)))
  )
)

(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
    (cdr record)
    false)
  )
)

(define (insert! key value table)
  (let ((pos (assoc key table)))
    (if pos
      (set-cdr! pos value)
      (set-cdr! table (cons (cons key value) (cdr table)))
;     (set-car! (cdr table) (cons key value)) <--- wrong
    )
  )
)

(define (lookup-v2 key1 key2 table)
  (let ((suitable (assoc key1 (cdr table))))
    (if suitable
      (let (record (assoc key2 (cdr suitable)))
        (if record)
          (cdr record)
          false
      )
      false
    )
  )
)

(define (insert!-v2 key1 key2 value table)
  (let ((suitable (assoc key1 (cdr table))))
    (if suitable
      (let (record (assoc key2 (cdr suitable)))
        (if record
          (set-cdr! record value)
          (set-cdr! suitable (cons (cons key2 value) (cdr suitable)))
        )
      )
      (set-cdr! table (c))
    )
  )
)
