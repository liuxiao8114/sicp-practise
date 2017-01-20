(define v (list 'a 'b 'c 'd))

(define w (mystery v))

v ---> a | b c d ---> b | c d ---> c | d ---> d | nil

x ---> a | b c d ---> b | c d ---> c | d ---> d | nil
             |
             nil

temp1 ---> b | c d
                |
                a | nil

temp2 ---> c | d
               |
               b | a
