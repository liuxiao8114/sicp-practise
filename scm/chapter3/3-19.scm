(define (loop? lst)
  (define (iter x y)
    (let ((x-walk (list-walk 1 x)))
          (y-walk (list-walk 2 y))
    )
  )
  (iter )
)

(define (list-walk step lst)
  (cond ((null? lst) '())
        ((= step 0) lst)
        (else (list-walk (- step 1) (cdr lst)))
  )
)

(define (loop? lst)
    (define (iter x y)
        (let ((x-walk (list-walk 1 x))
              (y-walk (list-walk 2 y)))
            (cond ((or (null? x-walk) (null? y-walk))
                    #f)
                  ((eq? x-walk y-walk)
                    #t)
                  (else
                    (iter x-walk y-walk)))))
    (iter lst lst))

(define (list-walk step lst)
    (cond ((null? lst)
            '())
          ((= step 0)
            lst)
          (else
            (list-walk (- step 1)
                       (cdr lst)))))

(define loop (list 'a 'b 'c 'd 'e))
(set-cdr! loop loop)
(define no-loop (list 'a 'b 'a))

;(loop? loop)
(iter loop loop)

(iter (cdr loop) (cdr (cdr loop)))
(iter (cdr (cdr loop)) (cdr (cdr (cdr (cdr loop)))))
(list-walk 1 loop)
(list-walk 0 (cdr loop))
(cdr loop)
(list-walk 2 loop)
(cdr (cdr loop))
;2017/12/5 参考答案: http://sicp.readthedocs.io/en/latest/chp3/19.html
;所谓常量空间, 即使用常数个变量解决问题
;参考答案中,一共3个函数: loop?, list-walk, iter(内部), 2个内部变量:x-walk, y-walk
