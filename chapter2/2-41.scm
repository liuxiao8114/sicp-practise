(load "2-2-3.scm")
(define (three-list n)
  (flatmap
    (lambda (x)
      (flatmap
        (lambda (y)
          (map (lambda (z) (list x y z)) (enum (- y 1))))
        (enum (- x 1))
      )
    )
    (enum n)
  )
)

(three-list 50)
