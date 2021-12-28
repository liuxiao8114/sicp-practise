4.1.1

## Apply

...Apply classifies procedures into two kinds: It calls `apply-primitive-procedure` to apply primitives; it applies compound procedures by sequentially evaluating the expressions that make up the body of the procedure.The environment for the evaluation of the body of a compound procedure is constructed by extending the base environment by the procedure to include a frame that binds the parameters of the procedure to the arguments to which the procedure is to be applied.

``
20201210 关于复合过程的环境的这段描述是什么意思？为什么需要`bind`?
``

20211221~20211226
大致重新梳理了4.1.1, 4.1.2的内容，重点整合了sicpjs的实现代码。

20211227
更新4.1.3章节，实现procejure/function.
