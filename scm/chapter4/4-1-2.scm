;;4.1.2 Representing Expressions
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)
  )
)

;;(quote <test-of-quotation>)
(define (quoted? exp) (tagged-list? exp 'quote))
(define (test-of-quotation exp) (cadr exp))
(define (tagged-list? exp tag)
  (if (pair? exp)
    (eq? (car exp) tag)
    false
  )
)

;;(set! <var> <value>)
(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

;;(define <var> <value>) or
;;(define (<var> <parameter1> <parameter2> <parameter3>...) (<body>))
;;<=> (define <var> (lambda (<parameter1> <parameter2> <parameter>) (<body>)))
(define (definition? exp) (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
    (cadr exp)
    (caddr exp)
  )
)
(define (definition-value exp)
  (if (symbol? (cadr exp))
    (caddr exp)
    (make-lambda (caddr exp) (cddr exp))
  )
)

;;lambda
(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters lambda) (cadr lambda))
(define (lambda-body lambda) (caddr lambda))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

;;if
;;(if (<if-predicate>) (<if-consequent>) (<if-alternative>))
(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false
  )
)

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative)
)

;;begin (begin <exp1> <exp2>...)
(define (beigin? exp) (tagged-list? exp 'begin))
(define (beigin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps? seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (car seq))
        (else (make-begin? seq))
  )
)
(define (make-beigin? seq) (cons 'begin seq))

;;application
(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operand ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

;;cond
;;(cond
;;  ((<cond-predicate> <cond-actions>) <exp1>)
;;  ((<cond-predicate> <cond-actions>) <exp2>)
;;  ...
;;  (else <exp>))
;;
(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))

(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))

(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

(define (expand-clauses clauses)
  (if (null? clauses)
    false
    (let ((first (car clauses))
          (rest (cdr clauses)))
      (if (cond-else-clause? first)
        (if (null? rest)
          (sequence->exp (cond-actions first))
          (error "ELSE clause is not last -- COND->IF")
        )
        (make-if
          (cond-predicate first)
          (cond-actions first)
          (expand-clauses rest)
        )
      )
    )
  )
)
