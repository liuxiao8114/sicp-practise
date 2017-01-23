(load "2-2-4.scm")

;匿名函数的递归方式：定义变量至递归底层最终返回值，然后写出递归过程
(define (split x y)
  (lambda (p n)
    (if (= n 0)
      p
      (let ((smaller ((split x y) p (- n 1))))
        (x p (y smaller smaller))
      )
    )
  )
)

;或者使用过程(函数)描述递归过程，然后返回该过程
(define (split-2 x y)
  (define inner p n)
    (if (= n 0)
      p
      (let (smaller (inner p (- n 1)))
        (x p (y smaller smaller))
      )
    )
  inner
)

(define right-split (split beside below) )

(right-split wave 5)

(define up-split (split below beside))
