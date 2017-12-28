(load "util.scm")

;分别定义复数的极坐标和直角坐标表示，定义各自的构造函数和选择函数(实部，虚部，模，幅角)
;定义生成标记的过程
;定义通用型选择过程
;定义构造函数选择过程
;定义复数运算过程

;Ben的实现,用直角坐标(rect)计算real-part,imag-part, magnitude, angle, 并实现给定坐标的构造函数
(define (real-part-rect z) (car z))

(define (imag-part-rect z) (cadr z))

(define (magnitude-rect z)
  (sqrt (+ (square (real-part-rect z)) (square (imag-part-rect z)))))

(define (angle-rect z)
  (atan (imag-part-rect z) (real-part-rect z)))

(define (make-from-real-imag-rect x y) (cons x y))

(define (make-from-mag-ang-rect r a)
  (cons (* r (cos a)) (* r (sin a))))

;Alyssa的实现,用极坐标(pola)计算real-part,imag-part, magnitude, angle, 构造函数
(define (real-part-pola z) (* (magnitude-pola z) (cos (angle-pola z))))

(define (imag-part-pola z) (* (magnitude-pola z) (sin (angle-pola z))))

(define (magnitude-pola z) (car z))

(define (angle-pola z) (cadr z))

(define (make-from-real-imag-pola x y) (cons (sqrt (+ (square x) (square y))) (atan y x)))

(define (make-from-mag-ang-pola r a) (cons r a))

;生成标记
(define (attach-tag type-tag contents)
  (cons type-tag contents))

;取得标记
(define (type-tag datum)
  (if (pair? datum)
    (car datum)
    (error "Bad tagged datum")
  )
)

;取得复数表示内容
(define (contents datum)
  (if (pair? datum)
    (cadr datum)
    (error "Bad contented datum")
  )
)

;定义通用选择
(define (real-part z)
  (cond ((eq? (type-tag z) 'rect) (real-part-rect (content z)))
        ((eq? (type-tag z) 'pola) (real-part-pola (content z)))
        (else (error "Unknown type: " z))
  )
)

(define (imag-part z)
  (cond ((eq? (type-tag z) 'rect) (imag-part-rect (content z)))
        ((eq? (type-tag z) 'pola) (imag-part-pola (content z)))
        (else (error "Unknown type: " z))
  )
)

(define (magnitude z)
  (cond ((eq? (type-tag z) 'rect) (magnitude-rect (content z)))
        ((eq? (type-tag z) 'pola) (magnitude-pola (content z)))
        (else (error "Unknown type: " z))
  )
)

(define (angle z)
  (cond ((eq? (type-tag z) 'rect) (angle-rect (content z)))
        ((eq? (type-tag z) 'pola) (angle-pola (content z)))
        (else (error "Unknown type: " z))
  )
)

;构造函数选择 -- 由于我们无法再根据标记进行选择,只能根据实现,直接指定rect方式
;(因为在运算过程中x一定为实部而y一定为虚部)
(define (make-from-real-imag x y) (make-from-real-imag-rect x y))
(define (make-from-mag-ang r a) (make-from-mag-ang-pola r a))

;复数运算过程
(define (add-complex z1 z2)
  (make-from-real-imag (+ (real-part z1) (real-part z2))
    (+ (imag-part z1) (imag-part z2))
  )
)

(define (multi-complex z1 z2)
  (make-from-mag-ang
    (+ (magnitude z1) (magnitude z2))
    (+ (angle z2) (angle z2))
  )
)
