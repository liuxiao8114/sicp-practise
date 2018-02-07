(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))


(expand 1 7 10)
10 1 ...3
30 4 ...2
20 2 ...6
60 8 ...4
40 5 ...5
50 7 ...1

(expand 3 8 10)
30 3 ...6
60 7 ...4
40 5 ...0
0  0 ...0 ...error at quotient
