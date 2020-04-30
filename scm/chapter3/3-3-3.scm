(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records) (car records)))
        (else (assoc key (cdr records)))
  )
)

;线性表顺序查找
(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
    (cdr record)
    false)
  )
)

(define (insert! key value table)
  (let ((pos (assoc key table)))
    (if pos
      (set-cdr! pos value)
      (set-cdr! table (cons (cons key value) (cdr table)))
;     (set-car! (cdr table) (cons key value)) <--- wrong
    )
  )
)

;二维表格&数组 n*n
;(list '*table* (list 'math (cons '+ 43) (cons '- 45)) (list 'letter (cons 'a 97) (cons 'b 98)))
(define (lookup-v2 key1 key2 table)
  (let ((suitable (assoc key1 (cdr table)))) ;<-- 根据key1查找对应的子列
    (if suitable
      (let (record (assoc key2 (cdr suitable))) ;<--如果找到,则在该子列中查找key2关键字的记录
        (if record)
          (cdr record)
          false
      )
      false
    )
  )
)

(define (insert!-v2 key1 key2 value table)
  (let ((suitable (assoc key1 (cdr table))))
    (if suitable
      (let (record (assoc key2 (cdr suitable)))
        (if record
          (set-cdr! record value)
          (set-cdr! suitable (cons (cons key2 value) (cdr suitable)))
        )
      )
      ;(set-cdr! table (list (cons key1 (cons key2 value))))
      (set-cdr! table (cons (list key1 (cons key2 value)) (cdr table))) ;<--子列第一个元素为key1(列名)，从第二个元素开始是各个元素
    )
  )
)
