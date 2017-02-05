(define (make-from-mag-ang m a)
  (define (dispatch op)
    (cond ((eq? op 'real-part) (atan )) ;<-- how to calulate this?
          ((eq? op 'magnitude) m)
          ((eq? op 'angle) a)
          (else (error "UNKNOWN op -- MAKE-FROM-MAG-ANG" op))
    )
  )
  dispatch
)
