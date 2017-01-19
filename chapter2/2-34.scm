(define (horner-eval x seq)
  (accumulate (lambda (a b) (+ a (* b x))) 0 seq))

(horner-eval 2 (list 1 3 0 5 0 1))
