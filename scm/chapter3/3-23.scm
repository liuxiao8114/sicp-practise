;first-insert o(1)
;rear-insert o(1)
;first-delete o(1)
;rear-delete o(n)
(define (make-deque-n)
  (let ((front-ptr '()) ;(cons cur next)
        (rear-ptr '())) ;(cons cur next)

    (define (set-ptr! e i) (set! e i)) ; <-- this won't be work! why???
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

(define (make-node cur prev next)
  (list cur prev next))

(define (update-cur n var)
  (set-car! n var))

(define (update-prev n var)
  (set-car! (cdr n) var))

(define (update-cur n var)
  (set-car! n var))

;18/01/16 实现困难！
;1. 对一个list, 不能直接用(set! (caddr l) x)直接改变当中的值.
;   即，更新当前的末端值使其next指向新的末端值没有一个合适的实现方式
;2. 不同于单向队列的直接向list末端添加pair(set-cdr! rear-ptr new-pair),
;   直接添加 or 更新 list 并不容易做到(因为list并不是直接定义的数据类型,
;   而只是cons嵌套表示的一种简写方式.以下的append操作的复杂度为o(n)
; (define rear (list 1 2 3)) (append rear (list 4 5 6)) => (list 1 2 3 4 5 6)
; (define rear '((1 2) (3 4))) (append rear '(5 6)) => '((1 2) (3 4) 5 6)
; 本质上, cons和list的操作有其适用的场合.
; 在接下来的make-deque-const-a的实现中,其实就是用(cons (cons cur prev) next),
; 代替了(list cur prev next)的结构
;
(define (make-deque-const)
  (let ((front-ptr '()) ;'(cur prev next)
        (rear-ptr '())) ;'(cur prev next)

    (define (set-front-ptr! i) (set! front-ptr i))
    (define (set-rear-ptr! i) (set! rear-ptr i))
    (define (empty-queue) (or (null? front-ptr) (null? (car front-ptr))))

    (define (rear-insert-queue! i)
      (let ((new-pair (list i '() '())))
        (cond ((null? front-ptr)
               (set! front-ptr new-pair)
               (set! rear-ptr new-pair))
              (else
               (set-car! (cdr new-pair) rear-ptr)
               (set-cdr! (cdr rear-ptr) new-pair)
               (set! rear-ptr new-pair)))
        front-ptr)
    )

    (define (front-insert-queue! i)
      (let ((new-list (list i '() (car front-ptr)))
            (prev-list (cadr front-ptr)))
        (if (empty-queue)
          (begin (set-front-ptr! new-list)
            (set-rear-ptr! new-list)
            front-ptr
          )
          (begin (set! prev-list new-list)
            (set-front-ptr! new-list)
            front-ptr
          )
        )
      )
    )

    (define (front-delete-queue!)
      (if (empty-queue)
        (error "empty queue!")
        (let ((next-list-prev (cadr (caddr front-ptr))))
          (begin (set! next-list-prev '())
            (set-front-ptr! (caddr front-ptr))
            front-ptr
          )
        )
      )
    )

    (define (rear-delete-queue!)
      (if (empty-queue)
        (error "empty queue!")
        (let ((prev-list-next (caddr (cadr rear-ptr))))
          (begin (set! prev-list-next '())
            (set-rear-ptr! (cadr rear-ptr))
            front-ptr
          )
        )
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

;(cons (cons 1 '()) '())
;(cons (cons 2 '()) (cons (cons 1 '()) '()))
(define (make-deque-const-a)
  (let ((front-ptr '())
        (rear-ptr '()))
    (define (make-deque) (cons front-ptr rear-ptr))
    (define (empty-deque?) (null? front-ptr))
    (define (set-front! item) (set! front-ptr item))
    (define (set-rear! item) (set! rear-ptr item))

    (define (get-item end)
      (if (empty-deque?)
        (error "Trying to retrieve item from empty deque")
        (caar end)
      )
    )

    (define (insert-deque! item end)
      (let ((new-pair (cons (cons item '()) '()))) ;(cons (cons cur prev) next)
        (cond ((empty-deque?)
                (set-front! new-pair)
                (set-rear! new-pair))
              ((eq? end 'front)
                (set-cdr! new-pair front-ptr)       ;set new-pair's next
                (set-cdr! (car front-ptr) new-pair) ;set front-ptr's prev
                (set-front! new-pair))              ;update new front-ptr
              (else
                (set-cdr! (car new-pair) rear-ptr)
                (set-cdr! rear-ptr new-pair)
                (set-rear! new-pair))
        )
      )
    )

    (define (front-insert-queue! item) (insert-deque! item 'front))
    (define (rear-insert-queue! item) (insert-deque! item 'rear))

    (define (rear-delete-queue!)
      (if (empty-deque?)
        (error "Trying to delete item from empty deque")
        (begin
          (set-rear! (cdr (car rear-ptr))) ;update new rear-ptr
          (set-cdr! rear-ptr '())
        )
      )
    )

    (define (front-delete-queue!)
      (if (empty-deque?)
        (error "Trying to delete item from empty deque")
        (begin
          (set-front! (cdr front-ptr)) ;update new front-ptr
          (set-cdr! (car front-ptr) '())
        )
      )
    )

    (define (front-deque) (get-item front-ptr))
    (define (rear-deque) (get-item rear-ptr))

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

;(define q (make-deque-n))
(define q (make-deque-const-a))

;(define x (cons 'a 'b))
;(define (set-xtr! e i) (begin (set! e i)) e)
;(set-xtr! x (cons 'b 'c))

(rear-insert-queue q 'a)

;(a b c d e f)
;((a '() b) (b a c) (c b d) (d c e) (e d '()))
;test set!:
;(define x '((a b c) (1 2 3) (4 5 6)))
;(define y (caddr x))
;(set! y (list 7 8 9))
