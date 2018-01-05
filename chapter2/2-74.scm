(define (get-record name companyname)
  ((get companyname 'record) name)
)

(define (personal-file a)
  ()
)

(define (get-salary name companyname)
  (get companyname 'salary)
)

(define (install-companyA-packgage)
  (define (record name)
    (get 'x name))

  (put 'A 'record record)
  (put 'A 'salary record)

  'done
)
