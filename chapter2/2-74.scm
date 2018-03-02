; each division's personnel records consist of a single file,
; which contains a set of records keyed on employees' names.

(define (type-tag datum)
  (cond ((pair? datum) (car datum))
        ((number? datum) 'scheme-number)
        (else (error "Bad tagged datum: " datum))
  )
)

(define (contents datum)
  (cond ((pair? datum) (cdr datum))
        ((number? datum) datum)
        (else (error "Bad contented datum: " datum))
  )
)

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (apply proc (map contents args))
        (error "No methods--" op)
      )
    )
  )
)

(define (add-person-in-file person file)
  (adjoin-set person file))

(define (add-content-in-record content record)
  (adjoin-set content record))

(define (get-record name file)
  ((apply-generic 'get-record file) name)
)

(define (get-salary record)
  ((apply-generic 'get-detail record) 'salary)
)

(define (find-employee-record name all-divisions-files)
  (filter (lambda (file) (get-record name file)) all-divisions-files)
)

(define (get-record-planB name file)
  ((get 'get-record (type-tag file)) (contents file) name)

(define (install-companyA-package)
  (define (tag process) (attach-tag 'A process))
  (define (make-file personnel-records) (list personnel-records))
  (define (make-record name contents) (cons name contents))

  ;in companyA's case both file and personal record have the same structure
  (define (get-record file)
    (define (get-detail-with-given-msg name)
      (cond ((null? file) false)
            ((eq? (caar file) name) (car file))
            (else ((get-record (cdr file)) name))
      )
    )
    get-detail-with-given-msg
  )

  ;get-record outside with no apply-generic
  (define (get-record-planB file name)
    (cond ((null? file) false)
          ((eq? (caar file) name) (car file))
          (else (get-record-planB (cdr file) name))
    )
  )

  (define (add-record record file)
    (cons record file))

  (define (get-detail record)
    (let ((content (contents record)))
      (define (get-detail-with-given-msg key)
        (if (eq? (caar content) key)
          (car content)
          ((get-detail (cdr content)) key)
        )
      )
      get-detail-with-given-msg
    )
  )

  (define (get-detail-planB record key)
    (cond ((null? record) false)
          ((eq? (caar record) key) (car record))
          (else (get-detail-planB (cdr record) key))
    )
  )

  (put 'get-record '(A) (lambda (file) (get-record file)))
  (put 'get-detail '(A) (lambda (record) (get-detail record)))
  (put 'make-record 'A (lambda (name contents) (tag (make-record name contents))))
  (put 'make-file 'A (lambda (records) (tag (make-file records))))

  'done
)

(define (install-companyB-package)
  (define (tag process) (attach-tag 'B process))
  (define (make-file records)
    (define (iter origin result)
      ()

    )
    (iter records '())
  )

  (define (make-record key contents) (cons key contents))

  (define (get-record key file)
    (if (eq? (caar file) key)
      (car file)
      (get-record key (cdr file))
    )
  )
  
  (define (add-record record file)
    (cons record file))

  (put 'get-record '(B) (lambda (record-key file) ()))
  (put 'get-salary 'B record)
  (put 'make-record 'B (lambda (key value) (tag (make-record key value))))
  (put 'make-file 'B (lambda (records) (tag (make-file records))))

  'done
)
