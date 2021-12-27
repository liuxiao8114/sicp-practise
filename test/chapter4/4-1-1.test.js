const path = require('path')

const SRC_ROOT = `../../src/chapter4/`
const { car, cdr, pair, isNull, list, map } = require(path.join(SRC_ROOT, 'utils'))
const { sicpEval, evaluate } = require(path.join(SRC_ROOT, '4-1-1'))

describe('chapter 4.1.1', () => {
  const NUMBER_TEST = 999
  const STRING_TEST = '123'

  it('tests sicpEval: self evaluate', () => {
    expect(sicpEval(NUMBER_TEST)).toBe(NUMBER_TEST)
    expect(sicpEval(STRING_TEST)).toBe(STRING_TEST)
  })

  it('tests evaluate: literal', () => {
    expect(evaluate(NUMBER_TEST)).toBe(NUMBER_TEST)
    expect(evaluate(STRING_TEST)).toBe(STRING_TEST)
  })
})

describe('4.1.1 exercises', () => {
  // Exercise 4.1
  // Notice that we cannot tell whether the metacircular evaluator evaluates argument expressions
  // from left to right or from right to left. Its evaluation order is inherited from the
  // underlying JavaScript: If the arguments to pair in map are evaluated from left to right,
  // then list_of_values will evaluate argument expressions from left to right; and if the
  // arguments to pair are evaluated from right to left, then list_of_values will evaluate
  // argument expressions from right to left.
  // Write a version of list_of_values that evaluates argument expressions from left to
  // right regardless of the order of evaluation in the underlying JavaScript. Also write a version
  // of list_of_values that evaluates argument expressions from right to left.
  it('exec4.1', () => {
    function listValues(exps, env) {
      return map(arg => sicpEval(arg, env), exps)
    }

    function reverse(l) {
      function iter(next, result) {
        if(isNull(next))
          return result
        return iter(cdr(next), pair(car(next), result))
      }

      return iter(l, null)
    }

    function listValuesFromRight(exps, env) {
      return map(arg => sicpEval(arg, env), reverse(exps))
    }

    expect(listValues(list(1, 2, 3))).toEqual(list(1, 2, 3))
    expect(listValuesFromRight(list(1, 2, 3))).toEqual(list(3, 2, 1))
  })
})
