(define (make-queue)
  (let ((front-ptr (lambda (q) (car q)))
        (rear-ptr (lambda (q) (cdr q))))

    (define (set-front-ptr! q i) (set-car! q i))
    (define (set-rear-ptr! q i) (set-cdr! q i))
    (define (empty-queue q)
      (null? (front-ptr q)))

    (define (insert-queue! q i)
      (let ((new-pair (cons i '())))
        (if(empty-queue q)
          (begin (set-front-ptr! q new-pair)
            (set-rear-ptr! q new-pair)
            q
          )
          (begin (set-cdr! (rear-ptr q) new-pair)
            (set-rear-ptr! q new-pair)
            q
          )
        )
      )
    )

    (define (delete-queue! q i)
      (if(empty-queue q)
        (error "empty queue! --" q)
        (begin (set-front-ptr! q (cdr (front-ptr q))) q)
      )
    )

    (define (dispatch m)
      (cond ((eq? m 'insert-queue!) (lambda (q i) (insert-queue! q i)))
            ((eq? m 'delete-queue!) (lambda (q i) (delete-queue! q i)))
            ((eq? m 'empty-queue) (lambda (q) (empty-queue q)))
      )
    )
    dispatch
  )
)

(define (make-queue-a)
  (let ((front-ptr '())
        (rear-ptr '()))

    (define (set-front-ptr! i) (set! front-ptr i))
    (define (set-rear-ptr! i) (set! rear-ptr i))
    (define empty-queue (null? front-ptr))

    (define (insert-queue! i)
      (let ((new-pair (cons i '())))
        (if empty-queue
          (begin (set-front-ptr! new-pair)
            (set-rear-ptr! new-pair)
            front-ptr
          )
          (begin (set-cdr! rear-ptr new-pair)
            (set-rear-ptr! new-pair)
            front-ptr
          )
        )
      )
    )

    (define (delete-queue! q i)
      (if(empty-queue q)
        (error "empty queue! --" q)
        (begin (set-front-ptr! q (cdr (front-ptr q))) q)
      )
    )

    (define (dispatch m)
      (cond ((eq? m 'insert-queue!) (lambda (i) (insert-queue! i)))
            ((eq? m 'delete-queue!) (lambda (q) (delete-queue! q)))
            ((eq? m 'empty-queue) (lambda (q) (empty-queue q)))
      )
    )
    dispatch
  )
)

(define insert-queue (lambda (q i) ((q 'insert-queue!) i)))
(define delete-queue (lambda (q) ((q 'delete-queue!) q)))

(define q1 (make-queue-a))
(insert-queue q1 'a)
