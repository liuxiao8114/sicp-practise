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
2-76.scm 首先要说明的是, message passing的做法, 与currying(柯里化)非常相像
```scheme
(define (make-from-real-imag x y)
  (define (dispatch op)
    (cond ((eq? op 'real-part) x)
          ((eq? op 'imag-part) y)
          ((eq? op 'magnitude) (sqrt (+ (square x) (square y))))
          ((eq? op 'angle) (atan y x))
          (else
           (error "Unknown op -- MAKE-FROM-REAL-IMAG" op))))
  dispatch
)
```
这种实现方式，避免了explicit dispatch的命名冲突问题。
如果添加类型的处理更多,用 data-dispatch更合适(避免命名冲突),
如果添加方法的处理更多,用 哪一个都无所谓(显式指派用的代码更少?)

2-78.scm提供了一种默认调用的数据类型的方式，即在type-tag判断时如果没有提取到type时
如何处理。这种处理方式类似于显式指派(explicit dispatch):
(define (add a b)
  (cond ((and (number? a) (number? b)) (add-number a b))
        ((and (ration? a) (rantion? b)) (add-ration a b))
  )
)

2018/2/22
2-73.scm 设问d:
由((get 'deriv (operator exp)) (operands exp) var)
变成((get (operator exp) 'deriv) (operands exp) var)

的问题背后,不仅是在put动作上位置的调换,其含义上似乎与接下来讨论的message passing有所联系,
即

2018/2/26 2-3-4.practise 2.67~2.72
huffman树的实现(Algorithms 有详细实现步骤):



2018/2/27 ~ 3/31 2-93.scm(practise 2.93 ~ 2.97)
止于2.96, 未完成reduce的实现。
(gcd-terms的实现结果由于remove了common-factor目前结果仍为fraction)
reduce的实现本身雷同于gcd并不困难。主要在于多项式的reduce机制仍需要单独研究。
