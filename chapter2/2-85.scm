(load "2-5-1.scm")

; how to convert a real to rational?
(define (project-complex z)
  (let ((real (real-part z)))
    (let ((r (<do sth to get rational>)))
      (if (equ? (raise r) z)
        <make-rational with new rational>
        false
      )
    )
  )
)

(define (project-rational z)
  (let ((numer ((get 'numer 'rational) z)))
    (let ((i (round numer)))
      (if (equ? (raise i) z)
        i
        false
      )
    )
  )
)

;(put 'subtype 'complex drop-complex)
;(put 'subtype 'rational drop-rational)
(put 'project 'complex project-complex)
(put 'project 'rational project-rational)

(define (project z) (apply-generic 'project z))

(define (drop z)
  (let ((p (project z)))
    (if p
      (drop p)
      z
    )
  )
)
