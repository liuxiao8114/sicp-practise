(load "3-3-2.scm")

(define (print-queue q) (car q))

(define q1 (make-queue))

(insert-queue! q1 'a)

(insert-queue! q1 'b)
(delete-queue! q1)
(delete-queue! q1)