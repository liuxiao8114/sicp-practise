(define (element-of-set? x s)
  (cond ((null? s) #f)
        ((equal? x (car s)) #t)
        (else (element-of-set? x (cdr s)))
  )
)

(define (adjoin-set x s)
  (if(element-of-set? x s)
    s
    (cons x s)
  )
)

(define (intersection-set s1 s2)
  (cond ((or (null? s1) (null? s2)) '())
        ((element-of-set? (car s1) s2) (cons (car s1) (intersection-set (cdr s1) s2)))
        (else (intersection-set (cdr s1) s2))
  )
)

(define (union-set s1 s2)
  (cond ((null? s1) s2)
        ((not (element-of-set? (car s1) s2)) (union-set (cdr s1) (cons (car s1) s2)))
        (else (union-set (cdr s1) s2))
  )
)

(define (element-of-set-2? x s)
  (cond ((null? s) #f)
        ((< x (car s)) #f)
        ((= x (car s)) #t)
        (else (element-of-set? x (cdr s)))
  )
)

(define (intersection-set-2 set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((> (car set1) (car set2)) (intersection-set-2 set1 (cdr set2)))
        ((< (car set1) (car set2)) (intersection-set-2 (cdr set1) set2))
        (else (cons (car set1) (intersection-set-2 (cdr set1) (cdr set2))))
  )
)

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right) (list entry left right))

(define (element-of-set?-tree e s)
  (cond ((= e (entry s)) #t)
    ((< e (entry s)) (element-of-set?-tree e (left-branch s)))
    ((> e (entry s)) (element-of-set?-tree e (right-branch s)))
  )
)

(define (adjoin-set-tree e s)
  (cond ((null? s) (make-tree e '() '()))
        ((= e (entry s)) set)
        ((< e (entry s)) (make-tree (entry s) (adjoin-set-tree e (left-branch s)) (right-branch s)))
        ((> e (entry s)) (make-tree (entry s) (left-branch s) (adjoin-set-tree e (right-branch s))))
  )
)

;(element-of-set? 3 (list 1 2 3))
;(intersection-set (list 1 2 3 4) (list 3 4 5 6))
;(union-set (list 12 3 4) (list 2 3 4 5))
;(intersection-set-2 (list 1 2 3 4) (list 3 4 5 6))
