(define (count-pairs x)
  (if (not (pair? x))
    0
    (+ 1
      (count-pairs (car x))
      (count-pairs (cdr x)))
  )
)

;((a b) (c d) (e f))
;(count-pairs (list (list 'a 'b) (list 'c 'd) (list 'e 'f)))
;(count-pairs (list 'a 'b 'c))
(count-pairs (list (list 'a 'd) 'b 'c))


;
;
;
;
;
