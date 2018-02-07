(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))
  )
)

;this won't work because no defination of (mapx car args)
(define (mapx proc . args)
  (if (null? (car args))
    '()
    (cons
      (apply + (mapx car args))
      (apply mapx (cons proc (mapx cdr args)))
    )
  )
)

(apply + (list 1 2 3 4) (list 10 20 30 40))
(cons (apply + (map car args))
  (apply map (cons + (map cdr args))))

(apply map (cons + '((1 2) (3 4)))) ;(4 6)
(apply map (list + '(1 2) '(3 4))) ;(4 6)  + but not '+
(apply map (cons* (list + '(1 2) '(3 4)))) ;(4 6)
(map + '(1 2) '(3 4))
;   (cons* obj1 obj2 ... objN-1 objN)
;<=>(cons  obj1 (cons obj2 ... (cons objN-1 objN)))
;(cons* (cons a b)) <=> (cons a b)
;(cons* (cons a '(b c))) <=> (a b c)
