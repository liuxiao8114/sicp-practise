;加权树
;length表示leave
;structure表示substree

;A binary mobile consists of two branches
;Each branch is a rod of a certain length,
;from which hangs either a weight or another binary mobile.
(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

;a.
(define (left-branch mobile) (car mobile))
(define (right-branch mobile) (cadr mobile))
(define (branch-length branch) (car branch))
(define (branch-structure branch) (cadr branch))

;b. analogous to sum all leaves(fringe?)
(define (weight-branch b)
  (let ((sub (branch-structure b)))
    (if (number? sub)
      sub
      (total-weight sub)
    )
  )
)

;detail construction
(define (total-weight mobile)
  (if (null? mobile)
    0
    (let ((l (left-branch mobile))
          (r (right-branch mobile)))
      (let ((structure-l (branch-structure l))
            (structure-r (branch-structure r)))
        (cond ((and (number? structure-l) (number? structure-r))
                (+ structure-l structure-r))
              ((number? structure-l) (+ structure-l (weight-branch r)))
              ((number? structure-r) (+ structure-r (weight-branch l)))
              (else (+ (weight-branch l) (weight-branch r)))
        )
      )
    )
  )
)

(define (weight-branch-another branch)
  (let ((sub (branch-structure branch)))
    (if (number? sub)
      sub
      (total-weight-another sub)
    )
  )
)

;higher abstraction
(define (total-weight-another mobile)
  (if (null? mobile)
    0
    (+
      (weight-branch-another (left-branch mobile))
      (weight-branch-another (right-branch mobile))
    )
  )
)

;test case:
(define a (make-branch 1 10))
(define b (make-branch 2 5))
(define c (make-branch 3 15))
(define d (make-branch 4 35))
(define e (make-branch 5 20))
(define m (make-mobile b c))
(define n (make-branch 6 m))

;(list (list 1 10) (list 6 (list (list 2 5) (list 3 15))))

;
(define (x a b)
  (cond ((and a b) (display "double true"))
        (a (display "a: true"))
        (b (display "b: true"))
        (else (display "double false"))
  )
)

;(x true true)
;(total-weight (make-mobile d n)) ; 35 + 5 + 15 = 55
;(total-weight-another (make-mobile d n)) ; 35 + 5 + 15 = 55

;c. describe whether mobile is balanced
(define (is-balanced mobile)
  (let ((l (left-branch mobile))
        (r (right-branch mobile)))
    (=
      (* (weight-branch l) (branch-length l))
      (* (weight-branch r) (branch-length r))
    )
  )
)

(is-balanced (make-mobile b c))

;d. How much do you need to change your programs
;   to convert to the new representation as defined below?
(define (make-mobile-d left right) (cons left right))
(define (make-branch-d length structure) (cons length structure))

;need to change the programs which use the process make-mobile or make-branch
;left-branch
;right-branch
;branch-length
;branch-structure

(define (subsets s)
  (if (null? s)
      (list '())
      (let ((rest (subsets (cdr s))))
        (append rest (map <??> rest)))))

(subsets (list 1 2))

(append (subsets (2)) (map <??> (subsets (2))))
(append (append (subsets '()) (map <??> (subsets '()))) (map (lambda (x) (cons 1 x)) (subsets (2))))

(append
  (append '('()) (map (lambda (x) (cons 2 x)) ('())))
  (map (lambda (x) (cons 1 x)) (append ('()) (map (lambda (x) (cons 2 x)) ('())))))

(append (append '('()) '(2)) (map (lambda (x) (cons 1 x)) (append ('()) '(2))))
(append (list '() '(2)) (map (lambda (x) (cons 1 x)) (list '() 2)))
(append (list '() '(2)) (list '(1) '(1 2)))
'('() (2) (1) (1 2))
