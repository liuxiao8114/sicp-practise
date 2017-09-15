(define (count-pairs x)
  (if (not (pair? x))
    0
    (+ 1
      (count-pairs (car x))
      (count-pairs (cdr x)))
  )
)

(define two (list 1 2))
(define one (cdr two))

(count-pairs (cons one two))

;09/15 为什么Ben的方法不行?
;原因就在于这一节的内容所介绍的,同一(或者说共享)和相等是两个不同的概念
;当共享发生时,两个指针指向的是同一个序对。而按照Ben的方法,这个序对将会被计入两次
;上面的例子定义的one和two,由于one与two共享了一个序对,实际上只有3个序对而Ben的方法的返回值为4
;再如3-16-2.scm的例子one,three,seven.其中three包含了两个序对, 一个是其本身,一个是car和cdr都指向的one.
;而seven包含了3个序对:seven本身,seven下的car和cdr共享的three,three下的car和cdr共享的one.
;用Ben的方法,对seven计数就成了7次
