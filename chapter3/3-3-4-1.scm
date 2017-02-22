;wire

(define (call-each p)
  (if (null? p)
    'done
    (begin ((car p)) (call-each (cdr p))) ;(car p) -> ((car p)) 执行(car p)
  )
)

(define (make-wire)
  (let ((signal-value 0) (action-proc '()))
    (define (set-signal! new-value)
      (if (not (= signal-value new-value))
        (begin (set! signal-value new-value)
          (call-each action-proc))
        'done
      )
    )
    (define (accept-action-proc! proc)
      (set! action-proc (cons proc action-proc))
      (proc)
    )
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
            ((eq? m 'set-signal!) set-signal!)
            ((eq? m 'add-action!) accept-action-proc!)
            (else error "Unknown oeration -- WIRE " m)
      )
    )
    dispatch
  )
)

(define (get-signal wire)
  (wire 'get-signal))

(define (set-signal wire new-value) ((wire 'set-signal!) new-value))

(define (add-action wire proc) ((wire 'add-action!) proc))
