(define a (cons 1 2))
(define (mult x y z)
  (* x y z))

(mult (car a) (car a) 2) ; 2

;对a的修改会反应到两个参数上:
(set-car! a 2)

(mult (car a) (car a) 2) ; 8

;但是两个参数并没有意识到他们引用的是同一个变量:
(define (mult-other x y z)
  (set! x 5)
  (* x y z))

(mult-other (car a) (car a) 2) ;20
