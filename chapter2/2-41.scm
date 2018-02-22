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

(three-list 5)

(define (triples n s)
  (flatmap
    (lambda (x)
      (map
        (lambda (y) (list x y (- s x y)))
        (filter (lambda (y) (and (< (+ x y) s) (< (- s x y) y))) (enum-interval 1 (- x 1)))
      )
    )
    (enum-interval 1 n)
  )
)

(triples 10 20)

(define (unique-pairs n)
  (flatmap
    (lambda (x) (map (lambda (y) (list x y)) (enum (- x 1))))
    (enum n)
  )
)

(define (triples-ver2 n s)
  (define (make-triples l)
    (list (car l) (cadr l) (- s (car l) (cadr l))))
  (map
    make-triples
    (filter
      (lambda (x)
        (let ((fir (car x))
              (sec (cadr x)))
          (and (< (- s fir sec) sec) (< (+ fir sec) s))
        )
      )
      (unique-pairs n)
    )
  )
)

(triples-ver2 10 20)
