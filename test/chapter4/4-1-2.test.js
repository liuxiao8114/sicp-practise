const path = require('path')

const SRC_ROOT = `../../src/chapter4/`
const { car, cdr, pair, isNull, list, map } = require(path.join(SRC_ROOT, 'utils'))
const { evaluate, unparse, } = require(path.join(SRC_ROOT, '4-1-1'))
const {
  isTaggedList,
  sicpIf,
  operatorCombinationToApplication,
  variable,
  assignment,
  begin,
  TAGS,
} = require(path.join(SRC_ROOT, '4-1-2'))

const TRUE = "yes"
const FALSE = "no"

describe('chapter 4.1.2', () => {
  it('composite if', () => {
    const { makeIf, isIf, getIfPredicate } = sicpIf
    const literalTruePredicate = 1
    const literalFalsePredicate = 0
    // const statePredicate = list()
    const TEST_IF_SIMPLE_TRUE = makeIf(literalTruePredicate, TRUE, FALSE)
    const TEST_IF_SIMPLE_FALSE = makeIf(literalFalsePredicate, TRUE, FALSE)
    console.log(TEST_IF_SIMPLE_TRUE.toString())
    console.log(TEST_IF_SIMPLE_FALSE.toString())

    expect(isIf(TEST_IF_SIMPLE_TRUE)).toBe(true)
    expect(getIfPredicate(TEST_IF_SIMPLE_TRUE)).toBe(literalTruePredicate)
    expect(evaluate(TEST_IF_SIMPLE_TRUE)).toBe(TRUE)
    expect(evaluate(TEST_IF_SIMPLE_FALSE)).toBe(FALSE)
  })

  it('composite assignment', () => {
    const { makeAssignment, isAssignment, assignmentVariable, assignmentValue } = assignment
    const x = variable.makeName('x')
    const xTo1 = makeAssignment(x, 1)
    const xToY = makeAssignment(x, 'y')
    const xToFn = makeAssignment(x, () => console.log(`assign x to function`))

  })

  it('sequence/begin', () => {
    const { makeBegin, isBegin, beginActions, getFirstExp, getRestExps, isLastExp } = begin
    const exp = makeBegin(list(1, 2, "1", "2"))

    expect(isBegin(exp)).toBe(true)
    expect(isBegin(list(''))).toBe(false)

    const seq = beginActions(exp)

    expect(getFirstExp(seq)).toBe(1)


  })

  it('operatorCombinationToApplication', () => {
    // const TEST_STRING_1 = 'x = 1'
    // const TEST_STRING_2 = 'y + 5'
    // const TEST_STRING_3 = 'true === false'

    const ONE = 1
    const x = variable.makeName('x')
    const xTo1 = assignment.makeAssignment(x, ONE)

    const TEST_LIST_1 = list('===', xTo1, ONE)
    // console.log(operatorCombinationToApplication(TEST_LIST_1).toString())
  })
})

describe('4.1.2 exercises', () => {
  /*
    (20([0-9]{2})(01|0[3-9]|1[0-2])01_20\2\3(3[01]))|(20(?<year2>[0-9]{2})0201_20<year2>022[8-9])
    (
      (20(?<y1>[0-9]{2})(?<m1>0[13578]|1[02])01_20\k<y1><m1>(31))|
      (20(?<y2>[0-9]{2})(?<m2>0[469]|11)01_20\k<y2>\k<m2>(30))|
      (20(?<y3>[0-9]{2})0201_20\k<y3>022[8-9])
    )$

    ((20(?<y1>[0-9]{2})(?<m1>0[13578]|1[02])01_20\k<y1><m1>(31))|(20(?<y2>[0-9]{2})(?<m2>0[469]|11)01_20\k<y2>\k<m2>(30))|(20(?<y3>[0-9]{2})0201_20\k<y3>022[8-9]))$

    Exercise 4.2
    The inverse of parse is called unparse. It takes as argument a tagged list as produced by
    parse and returns a string that adheres to JavaScript notation.

    a. Write a function unparse by following the structure of evaluate (without the environment
    parameter), but producing a string that represents the given component, rather
    than evaluating it. Recall from section 3.3.4 that the operator + can be applied to two
    strings to concatenate them and that the primitive function stringify turns values
    such as 1.5, true, null and undefined into strings. Take care to respect operator precedences
    by surrounding the strings that result from unparsing operator combinations
    with parentheses (always or whenever necessary).

    b. Your unparse function will come in handy when solving later exercises in this section.
    Improve unparse by adding " " (space) and "\n" (newline) characters to the result
    string, to follow the indentation style used in the JavaScript programs of this book.
    Adding such whitespace characters to (or removing them from) a program text in order
    to make the text easier to read is called pretty-printing.
  */
  describe('exec4.2', () => {
    const TEST_IF_STRING = 'if(1) { "yes" } else { "no" } '

    it('unparse if', () => {
      expect(TAGS.SYMBOL).toBe('symbol')
      // const { makeIf } = sicpIf
      // const TEST_IF_SIMPLE_TRUE = makeIf(1, TRUE, FALSE)
      //
      // expect(unparse(TEST_IF_SIMPLE_TRUE)).toBe(TEST_IF_STRING)
    })

    it('unparse sequence', () => {
      // const { makeBegin } = begin
      // const seq = makeBegin(list(1, 2, "1", "2"))
      //
      // console.log(unparse(seq))
      // parse("const size = 2; 5 * s  ize;")
      // list(
      //   "sequence",
      //   list(
      //     list(
      //       "constant_declaration",
      //       list("name", "size"),
      //       list("literal", 2)
      //     ),
      //     list("binary_operator_combination", "*", list("literal", 5), list("name", "size"))
      //   )
      // ).toString()

      // console.log(new Map()) // eslint-disable-line
    })
  })
})

/*
  Exercise 4.3
  Rewrite evaluate so that the dispatch is done in data-directed style. Compare this with
  the data-directed differentiation function of exercise 2.73.

  Exercise 4.4
  Recall from section 1.1.6 that the logical composition operations && and || are syntactic
  sugar for conditional expressions: The logical conjunction expression1 && expression2
  is syntactic sugar for expression1 ? expression2 : false, and the logical disjunction
  expression1 || expression2 is syntactic sugar for expression1 ? true : expression2. They
  are parsed as follows:
  << expression1 logical-operation expression2 >> =
    list(
      "logical_composition",
      "logical-operation",
      list(<< expression1 >>, << expression2 >>)
    )
  where logical-operation is && or ||. Install && and || as new syntactic forms for the
  evaluator by declaring appropriate syntax functions and evaluation functions eval_and
  and eval_or. Alternatively, show how to implement && and || as derived components.

  Exercise 4.5
  a. In JavaScript, lambda expressions must not have duplicate parameters. The evaluator
  in section 4.1.1 does not check for this.
  • Modify the evaluator so that any attempt to apply a function with duplicate parameters
  signals an error.
  • Implement a verify function that checks whether any lambda expression in a given
  program contains duplicate parameters. With such a function, we could check the
  entire program before we pass it to evaluate.
  In order to implement this check in an evaluator for JavaScript, which of these two
  approaches would you prefer? Why?
  b. In JavaScript, the parameters of a lambda expression must be distinct from the names
  declared directly in the body block of the lambda expression (as opposed to in an inner
  block). Use your preferred approach above to check for this as well.

  Exercise 4.6
  The language Scheme includes a variant of let called let*. We could approximate the
  behavior of let* in JavaScript by stipulating that a let* declaration implicitly introduces
  a new block whose body includes the declaration and all subsequent statements of the
  statement sequence in which the declaration occurs. For example, the program

  let* x = 3;
  let* y = x + 2;
  let* z = x + y + 5;
  display(x * z);

  displays 39 and could be seen as a shorthand for
  {
    let x = 3;
    {
      let y = x + 2;
      {
        let z = x + y + 5;
        display(x * z);
      }
    }
  }

  a. Write a program in such an extended JavaScript language that behaves differently when
  some occurrences of the keyword let are replaced with let*.
  b. Introduce let* as a new syntactic form by designing a suitable tagged-list representation
  and writing a parse rule. Declare a syntax predicate and selectors for the tagged-list
  representation.
  c. Assuming that parse implements your new rule, write a let_star_to_nested_let
  function that transforms any occurrence of let* in a given program as described
  above. We could then evaluate a program p in the extended language by running
  evaluate(let_star_to_nested_let(p)).
  d. As an alternative, consider implementing let* by adding to evaluate a clause that
  recognizes the new syntactic form and calls a function eval_let_star_declaration.
  Why does this approach not work?
*/