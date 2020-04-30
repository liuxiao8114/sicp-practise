(define x '(1 (2 (3 (4 (5 (6 7)))))))

(car x) ;1
(cadr x) ;(2 (3 (4 (5 (6 7)))))
(cadadr x) ;(3 (4 (5 (6 7))))
(cadadr (cadadr (cadadr x))) ;7
