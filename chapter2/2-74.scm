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

(define (get-record key employee-name)
  (apply-generic ((get 'all 'file) employee-name))
)

(define (make-personal-file employee-name file)
  (cons employee-name file))

(define (get-salary name companyname)
  ((get companyname 'salary) )
)

(define (add-record-in-file record file)
  (adjoin-set record file))

(define (add-content-in-record content record)
  (adjoin-set content record))

(define (find-employee-record)
  ())

(define (install-companyA-package)
  (define (tag process) (attach-tag 'A process))
  (define (make-file records) (list records))
  (define (make-record key contents) (cons key contents))

  (put 'A 'get-record (lambda (record-key employee-name) ()))
  (put 'A 'get-salary record)
  (put 'A 'make-record (lambda (key value) (tag (make-record key value))))
  (put 'A 'make-file (lambda (records) (tag (make-file records))))

  'done
)
