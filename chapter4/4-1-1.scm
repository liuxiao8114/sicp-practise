;;Combinations
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((definition? exp) (eval-definition exp env))
        ((assignment? exp) (eval-assignment exp env))
        ((application? exp)
          (apply
            (eval (operator exp) env)
            (list-of-values (operands exp) env)
          )
        )
  )
)

(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
          (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
          (eval-sequence
            (procedure-body procedure)
            (extend-environment
              (procedure-parameters procedure)
              arguments
              (procedure-environment procedure)
            )
          )
        )
        (else (error "Unknown procedure type -- APPLY" procedure))
  )
)

;;Procedure arguments
(define (list-of-values ops env)
  (if (no-operand ops)
    '()
    (cons (eval (first-operand ops) env) (list-of-values (rest-operands ops) env))
  )
)

;;Conditionals
;;The if-predicate is evaluated in the language being implemented and thus yields a value in
;;that language.The interpreter predicate true? translates that value into a value that can be
;;tested by the if in the implementation language:
(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)
  )
)

;;Sequence
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env)
        )
  )
)

;;Assignment and definitions
(define (eval-assignment exp env)
  (set-variable-value!
    (assignment-variable exp)
    (eval (assignment-value exp) env)
    env
  )
)
(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
    (eval (definition-value exp) env)
    env
  )
  'OK
)
