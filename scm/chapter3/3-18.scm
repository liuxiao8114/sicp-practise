(define (memq? x list)
  (cond ((null? list) #f)
        ((eq? x (car list)) #t)
        (else (memq? x (cdr list)))
  )
)

(define (loop? l)
  (define (iter x temp)
    (cond ((not (pair? x)) #f)
          ((memq? (car x) temp) #t)
          (else (iter (cdr x) (cons (car x) temp)))
    )
  )

  (iter l '())
)


(define (loop2? lst)
    (let ((identity (cons '() '())))
        (define (iter remain-list)
            (cond ((null? remain-list)
                    #f)
                  ((eq? identity (car remain-list))
                    #t)
                  (else
                    (set-car! remain-list identity)
                    (iter (cdr remain-list)))))
        (iter lst)))

(define loop (list 'a 'b))
(set-cdr! loop loop)
(define no-loop (list 'a 'b 'a))

;(loop? loop)
;(loop? no-loop)

;2017/12/5 重写的loop在测试no-loop时仍有问题
;原因就在于这一节所讨论的同一和相等问题(如何判断(cons 'a '()) 和另一个(cons 'a '()) 是同一还是相等?)
;参考的答案 http://sicp.readthedocs.io/en/latest/chp3/18.html
;解法为: 设置一个参考序对identity(为避免恰好相等,参考解设为(cons '() '())),
;每当比较(car lst)与identity不等时，为car 重赋值identity.
;这样, 如果存在环,以后必然会有指针重新定位为之前标记过的identity, 即必然会造成相等。
;最坏情况需要比较lst.length - 1次(最后一个序对与某个序对相等)
