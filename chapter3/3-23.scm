(define (make-deque-n)
  (let ((front-ptr '())
        (rear-ptr '()))

    (define (set-ptr! e i) (set! e i)) ; <-- this won't be work!
    (define (set-front-ptr! i) (set! front-ptr i))
    (define (set-rear-ptr! i) (set! rear-ptr i))
    (define (empty-queue) (null? front-ptr))

    (define (rear-insert-queue! i)
      (let ((new-pair (cons i '())))
        (if (empty-queue)
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

    (define (front-insert-queue! i)
      (let ((new-pair (cons i '())))
        (if (empty-queue)
          (begin (set-front-ptr! new-pair)
            (set-rear-ptr! new-pair)
            front-ptr
          )
          (begin (set-front-ptr! (cons i front-ptr))
            front-ptr
          )
        )
      )
    )

    (define (front-delete-queue!)
      (if (empty-queue)
        (error "empty queue!")
        (begin (set-front-ptr! (cdr front-ptr)) front-ptr)
      )
    )

    (define (rear-delete-queue!)
      (if (empty-queue)
        (error "empty queue!")
        (begin
          (let ((x (penul-timate front-ptr)))
            (set-cdr! x '())
            (set-rear-ptr! x))
          front-ptr
        )
      )
    )

    (define (penul-timate q)
      (if(null? (cdr (cdr q)))
        q
        (penul-timate (cdr q))
      )
    )

    (define (dispatch m)
      (cond ((eq? m 'front-insert-queue!) front-insert-queue!)
            ((eq? m 'front-delete-queue!) front-delete-queue!)
            ((eq? m 'rear-insert-queue!) rear-insert-queue!)
            ((eq? m 'rear-delete-queue!) rear-delete-queue!)
            ((eq? m 'empty-queue) empty-queue)
            ((eq? m 'front-ptr) front-ptr)
            ((eq? m 'rear-ptr) rear-ptr)
      )
    )
    dispatch
  )
)

(define (make-deque-const)
  (let ((front-ptr '())
        (rear-ptr '()))

    (define (set-front-ptr! i) (set! front-ptr i))
    (define (set-rear-ptr! i) (set! rear-ptr i))
    (define (empty-queue) (null? front-ptr))

    (define (rear-insert-queue! i)
      (let ((new-list (list (car rear-ptr) i '())))
        (if (empty-queue)
          (begin (set-front-ptr! (list '() i '()))
            (set-rear-ptr! (list '() i '()))
            front-ptr
          )
          (begin (set! rear-ptr new-list)
            (set-ptr! new-pair)
            front-ptr
          )
        )
      )
    )

    (define (front-insert-queue! i)
      (let ((new-pair (cons i '())))
        (if (empty-queue)
          (begin (set-front-ptr! new-pair)
            (set-rear-ptr! new-pair)
            front-ptr
          )
          (begin (set-front-ptr! (cons i front-ptr))
            front-ptr
          )
        )
      )
    )

    (define (front-delete-queue!)
      (if (empty-queue)
        (error "empty queue!")
        (begin (set-front-ptr! (cdr front-ptr)) front-ptr)
      )
    )

    (define (rear-delete-queue!)
      (if (empty-queue)
        (error "empty queue!")
        (begin
          (let ((x (penul-timate front-ptr)))
            (set-cdr! x '())
            (set-rear-ptr! x))
          front-ptr
        )
      )
    )

    (define (penul-timate q)
      (if(null? (cdr (cdr q)))
        q
        (penul-timate (cdr q))
      )
    )

    (define (dispatch m)
      (cond ((eq? m 'front-insert-queue!) front-insert-queue!)
            ((eq? m 'front-delete-queue!) front-delete-queue!)
            ((eq? m 'rear-insert-queue!) rear-insert-queue!)
            ((eq? m 'rear-delete-queue!) rear-delete-queue!)
            ((eq? m 'empty-queue) empty-queue)
            ((eq? m 'front-ptr) front-ptr)
            ((eq? m 'rear-ptr) rear-ptr)
      )
    )
    dispatch
  )
)

(define front-insert-queue (lambda (q i) ((q 'front-insert-queue!) i)))
(define front-delete-queue (lambda (q) ((q 'front-delete-queue!))))
(define rear-insert-queue (lambda (q i) ((q 'rear-insert-queue!) i)))
(define rear-delete-queue (lambda (q) ((q 'rear-delete-queue!))))
(define empty-queue (lambda (q) ((q 'empty-queue))))
(define front-ptr (lambda (q) (q 'front-ptr)))
(define rear-ptr (lambda (q) (q 'rear-ptr)))

(define q (make-deque-n))

;(define x (cons 'a 'b))
;(define (set-xtr! e i) (begin (set! e i)) e)
;(set-xtr! x (cons 'b 'c))

(rear-insert-queue q 'a)
(rear-insert-queue q 'b)
(rear-insert-queue q 'c)
(rear-insert-queue q 'd)
(rear-insert-queue q 'e)
(rear-delete-queue q)
(rear-delete-queue q)
(rear-delete-queue q)
(rear-delete-queue q)
(rear-insert-queue q 'b)
(rear-insert-queue q 'c)
