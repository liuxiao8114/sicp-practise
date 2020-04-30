(define (averager in1 in2 out)
  (let ((midd (make-connector))
        (mu (make-connector)))
    (adder in1 in2 midd)
    (multiplier out mu midd)
    (constant 2 mu)
    'ok
  )
)
