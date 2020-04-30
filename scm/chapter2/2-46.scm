(define (make-vect x y)
  (cons x y))

(define (xcor-vect r)
  (car r))

(define (ycor-vect r)
  (cdr r))

(define (add-vect r1 r2)
  (make-vect (+ (xcor-vect r1) (xcor-vect r2)) (+ (ycor-vect r1) (ycor-vect r2)))
)

(define (sub-vect r1 r2)
  (make-vect (- (xcor-vect r1) (xcor-vect r2)) (- (ycor-vect r1) (ycor-vect r2)))
)

(define (scale-vect s r)
  (make-vect (* s (xcor-vect r)) (* s (ycor-vect r)))
)
