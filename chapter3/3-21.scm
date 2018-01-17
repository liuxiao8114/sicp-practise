(load "3-3-2.scm")

(define (print-queue q) (car q))

(define q1 (make-queue))

(insert-queue! q1 'a)

(insert-queue! q1 'b)
(delete-queue! q1)
(delete-queue! q1)

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
