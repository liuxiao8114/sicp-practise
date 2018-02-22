2018/1/3
2-73.scm 增加variable?(覆盖Schme的定义) 和same-variable? 函数

2018/1/4
2-75.scm message passing的apply-proc实现,与2-4-3.scm的实现差异。

(define (apply-generic op args)
  (let ((type-tags (list (type-tag args)))) ;<- for (put '(rect) xxx)
    (let ((proc (get op type-tags))) ; 由type-tags取得op的调用函数
      (if proc
        (proc (contents args))
        (error "No methods--" op)
      )
    )
  )
)
(apply-generic 'real-part (list 'rect 1 2))

(define (apply-generic op arg) (arg op))
(apply-generic 'real-part (make-from-real-imag 1 2))

2-4-3.scm中,args形式为(list 'rect 1 2), (list 'pola 10 60),
(make-from-real-imag 1 2)

2.4.3的message passing这一节所表达的内容
...decompose the table into columns and,instead of using "intelligent operations" that
dispatch on data types,to work with "intelligent data objects" that dispatch on operation names.

...This style of programming is called message passing.
The name comes from the image that a data object is an entity that
receives the requested operation name as a "message."

              rect            pola
----------------------------------
real-part      
imag-part
magnitude
angle

2018/2/21
2-78.scm提供了一种默认调用的数据类型的方式，即在type-tag判断时如果没有提取到type时
如何处理。这种处理方式类似于message passing:
(define (add a b)
  (cond ((and (number? a) (number? b)) (add-number a b))
        ((and (ration? a) (rantion? b)) (add-ration a b))
)

类比dispatch?

2018/2/22
2-73.scm 设问d:
由((get 'deriv (operator exp)) (operands exp) var)
变成((get (operator exp) 'deriv) (operands exp) var)

的问题背后,不仅是在put动作上位置的调换,更进一步的apply-generic的取type的对象也需要变化。

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (apply proc (map contents args))
        (error "No methods--" op)
      )
    )
  )
)
