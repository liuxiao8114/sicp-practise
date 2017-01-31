(load "util.scm")

;定义复数运算过程
;分别定义复数的极坐标和直角坐标表示，定义各自的构造函数和选择函数(实部，虚部，模，幅角)
;定义生成标记的过程
;定义通用型选择过程
;为复数运算中复数构造函数指定实现过程

(define (add-complex z1 z2)
  (make-from-real-imag (+ (real-part z1) (real-part z2))
    (+ (imag-part z1) (imag-part z2))
  )
)

(define (real-part-rect z) (car z))

(define (imag-part-rect z) (cadr z))

(define (magnitude-rect z)
  (sqrt (+ (square (real-part-rect z)) (square (imag-part-rect z)))))

(define (angle-rect z)
  (atan (imag-part-rect z) (real-part-rect z)))

(define (make-from-real-imag-rect x y) (cons x y))

(define (make-from-mag-ang-rect r a)
  (cons (* r (cos a)) (* r (sin a))))

(define (magnitude-pola z) (car z))
(define (angle-pola z) (cadr z))

(define (real-part-pola z) (* (magnitude-pola z) (cos (angle-pola z))))

(define (imag-part-pola z) (* (magnitude-pola z) (sin (angle-pola z))))

(define (make-from-real-imag-pola x y) (cons (sqrt (+ (square x) (square y))) (atan y x)))

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
    (car datum)
    (error "Bad tagged datum")
  )
)

(define (contents datum)
  (if (pair? datum)
    (cadr datum)
    (error "Bad contented datum")
  )
)
