4.1.1

## Apply

...Apply classifies procedures into two kinds: It calls `apply-primitive-procedure` to apply primitives; it applies compound procedures by sequentially evaluating the expressions that make up the body of the procedure.The environment for the evaluation of the body of a compound procedure is constructed by extending the base environment by the procedure to include a frame that binds the parameters of the procedure to the arguments to which the procedure is to be applied.

``
20201210 关于复合过程的环境的这段描述是什么意思？为什么需要`bind`?
``
