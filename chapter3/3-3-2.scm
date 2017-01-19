(define (front-ptr queue) (car queue))

(define (rear-ptr queue) (cdr queue))

(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (make-queue)
  (cons '() '()))

(define (empty-queue? q)
  (null? (front-ptr q)))

(define (front-queue queue)
  (if(empty-queue? queue)
    (error "FRONT called with an empty queue" q)
  )
)

(define (insert-queue! q i)
  (let ((new-pair (cons i '())))
    (cond ((empty-queue? q) ((set-front-ptr! q new-pair) (set-rear-ptr! q new-pair) q))
          (else
            (set-cdr! (rear-ptr q) new-pair)
            (set-rear-ptr! q new-pair)
            q
          )
    )
  )
)

(define (delete-queue! q)
  (cond ((empty-queue? q) "empty queue")
        (else (set-front-ptr! q (cdr (front-queue q))) q)
  )
)

;(cdr q)
;(cdr (front-queue q))
