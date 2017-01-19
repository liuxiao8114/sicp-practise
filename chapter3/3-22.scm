(define (make-queue)
  (let ((front-ptr (lambda (q) (car q)))
        (rear-ptr (lambda (q) (cdr q))))

    (define (set-front-ptr! q i) (set-car! q i))
    (define (set-rear-ptr! q i) (set-cdr! q i))
    (define (empty-queue q)
      (null? (front-ptr q)))

    (define (insert-queue! q i)
      (let ((new-pair (cons i '())))
        (if(empty-queque q)
          ((set-front-ptr! q new-pair)
            (set-rear-ptr! q new-pair)
          )
          ((set-cdr! (rear-ptr q) new-pair)
            (set-rear-ptr! q new-pair)
          )
        )
      )
    )

    (define (delete-queue! q i)
      (if(empty-queque q)
        (error "empty queue! --" q)
        ((set-front-ptr! q (cdr (front-ptr q))) q)
      )
    )

    (define (dispatch m)
      (cond ((eq? m 'insert-queue!) (lambda (q i) (insert-queue! q i)))
            ((eq? m 'delete-queue!) (lambda (q i) (delete-queue! q i)))
      )
    )
    dispatch
  )
)

(define insert-queue (q 'insert-queue!))
(define delete-queue (q 'delete-queue!))

(define q1 (make-queue))

(insert-queue q1 'a)
