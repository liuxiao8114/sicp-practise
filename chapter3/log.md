2018/3/5
3.5.1
There is a similar relationship between streams and ordinary lists.
The difference is the time at which the elements are evaluated.
With ordinary lists, both the car and cdr are evaluated at construction time.
With streams, the cdr is evaluated at selection time.

2018/3/7
3-55.scm
(define (partial-sums s)
  (cons-stream 0 (add-streams s (partial-sums s))))
(partial-sums integers)

(define partial-sums
  (cons-stream 0 (add-streams partial-sums integers)))

上面的第一种实现, 在3-61.scm有类似的过程：
(define (invert-unit-series s)
  (cons-stream 1 (scale-stream (mul-series (stream-cdr s) (invert-unit-series s)) -1))
)
在body中直接递归调用(partial-sums s)的方式相当于create a new stream?
会不会导致这一节中一直强调的memorize无效?

然后http://community.schemewiki.org/?sicp-ex-3.61
又给出了这种解法(如同上面第二种的partial-sums)：

(define (invert-unit-series series)
  (define inverted-unit-series
    (cons-stream 1 (scale-stream (mul-streams (stream-cdr series)
                                              inverted-unit-series)
                                 -1)))
  inverted-unit-series)

3-63.scm又讨论了这个问题. 这种递归调用会生成新的stream而导致不能利用memorize的结果.
所以当过程中产生递归调用stream时，如果递归中参数的stream就是原stream应避免直接递归。
(比较partial-sums, sqrt-stream 和 mul-series, pi-summands的实现差异)

3-59.scm
cosine-series与sine-series能实现的原因正如正文中的对prime所解释的:
at any point, enough of the primes stream has been generated
to test the primality of the numbers we need to check next.

(define primes
  (cons-stream
   2
   (stream-filter prime? (integers-starting-from 3))))

(define (prime? n)
  (define (iter ps)
    (cond ((> (square (stream-car ps)) n) true)
          ((divisible? n (stream-car ps)) false)
          (else (iter (stream-cdr ps)))))
  (iter primes))

2018/03/08
3-60.scm
两种多项式分解的不同解法，注意每个stream的实现。
