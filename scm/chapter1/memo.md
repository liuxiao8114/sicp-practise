## 1.1 The Elements of Programming
```
Every powerful language has threee mechanisms for providing for combining simple ideas to form more complex ideas.
```
### 1.1.1 Expressions
```
Expressions formed by delimiting a list of expressions within parentheses in order to denote procedure application, are called combinations.

Even with complex expressions, the interpreter always operates in the same basic cycle:
It reads an expression from the terminal, evaluates the expression, and prints the result.
This mode of operation is often expressed by saying that the interpreter runs in a *read-eval-print-loop*.
```
### 1.1.2 Naming and the Environment
```
The possibility of associating values with symbols and later retrieving them means that
the interpreter must maintain some sort of memory that keeps track of the name-object pairs.
This memory is called the *environment*.
```

### 1.1.3 Evaluating Combinations
```
We take care of the primitive cases by stipulating that
- the values of numeralsare the numbers that they name,

- the values of built-in operators are the machine instruction sequences that carry out the corresponding operations, and

- the
```

## 1.2 Procedures and the Processes They Generate

## 1.3 Formulating Abstractions with Higher-Order Procedures
```
One of the things we should demand from a powerful programming language is the ability to build abstractions by assigning names to common patterns and then to work in terms of the abstractions directly.Procedures provide this ability.
```
