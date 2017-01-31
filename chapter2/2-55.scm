(car '')

;(car '(a b c)) <=> (car (quote (a b c)))
;(car ''abc) <=> (car (quote (quote abc))) <=> (car (cons quote (quote abc)))
