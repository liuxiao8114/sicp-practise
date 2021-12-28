// 4.1.1 The core of the evaluator
// some parts are implemented in the fellow section
const { car, cdr, map } = require('./utils')

const {
  SYMBOL, IF, SEQUENCE, ASSIGNMENT, LAMBDA, BLOCK,
  isVariable,
  isSelfEvaluating,
  isTaggedList, isQuoted, getTextQuotation, getTag,
  isDefinition, getDefinitionVariable, getDefinitionValue,
  isAssignment, assignmentVariable, assignmentValue,
  isIf, getIfPredicate, getIfConsequent, getIfAlternative,
  isBegin, beginActions, getFirstExp, getRestExps, isLastExp, isEmptySequence,
  isLambda, getLambdaParameters, getLambdaBody,
  isApplication, getOperator, getOperands,
} = require('./4-1-2.js')

const {
  // Test of predicates
  isTruthy, isFalsy,
  // Representing procedures
  isPrimitiveProcedure, applyPrimitiveProcedure,
  makeProcedure, isCompondProcedure, getProcedureParameters, getProcedureBody, getProcedureEnvironment,
  // Representing return values
  isReturnValue, returnValueContent,
  // Operations on Environments
  lookupVariableValue, extendEnvironment, $defineVariable, $setVariableValue,
} = require('./4-1-3.js')

/*
  Each type of component has a syntax predicate that tests for it
  and an abstract means for selecting its parts.
  1. Primitive expression
    1-1. Number, String, Boolean, Null
    1-2. Variable
  2. Combination
    2-1. function application
    2-2. operator combination => function application
  3. Syntactic form
    3-1. condition
    3-2. lambda
    3-3. sequence => about the evaluate order
    3-4. block => about the environment
    3-5. return
    3-6. function declaration
    3-7. constant or variable declaration or assignment
*/
function sicpEval(exp, env) {
  if(isSelfEvaluating(exp))
    return exp
  else if(isVariable(exp))
    return lookupVariableValue(exp, env)
  else if(isQuoted(exp))
    return getTextQuotation(exp)
  else if(isAssignment(exp))
    return evalAssignment(exp, env)
  else if(isDefinition(exp))
    return evalDefinition(exp, env)
  else if(isIf(exp))
    return evalIf(exp, env)
  else if(isLambda(exp))
    return makeProcedure(
      getLambdaParameters(exp),
      getLambdaBody(exp),
      env
    )
  else if(isBegin(exp))
    return evalSequence(beginActions(exp), env)
  else if(isApplication(exp)) {
    return sicpApply(
      sicpEval(getOperator(exp), env),
      listOfValues(getOperands(exp), env)
    )
  }
}

function sicpApply(procedure, args) {
  if(isPrimitiveProcedure(procedure))
    return applyPrimitiveProcedure(procedure, args)
  if(isCompondProcedure(procedure))
    return evalSequence(
      getProcedureBody(procedure),
      extendEnvironment(
        getProcedureParameters(procedure),
        args,
        getProcedureEnvironment(procedure)
      )
    )

  throw new Error(`Unknown procedure type -- Apply: ${procedure}`)
}

function sicpJsEval() {
  const _table = new Map() // eslint-disable-line

  _table.set(SYMBOL, (exp, env) => lookupVariableValue(exp, env))
  _table.set(IF, evalIf)
  _table.set(SEQUENCE, (exp, env) => evalSequence(beginActions(exp), env))
  _table.set(ASSIGNMENT, evalAssignment)
  _table.set(LAMBDA, (exp, env) => makeProcedure(getLambdaParameters(exp), getLambdaBody(exp), env))
  _table.set(BLOCK, (exp, env) => {

  })

  // _table.set(isVariable, (exp, env) => lookupVariableValue(exp, env))
  // _table.set(isIf, evalIf)
  // _table.set(isBegin, (exp, env) => evalSequence())
  // _table.set(isAssignment, evalAssignment)
  // _table.set(isLambda, (exp, env) => makeProcedure(getLambdaParameters(exp), getLambdaBody(exp), env))

  function dispatch(component, env) {
    if(isSelfEvaluating(component))
      return component

    const _eval = _table.get(car(component))
    if(typeof _eval === 'function')
      return _eval(component, env)

    throw new Error(`Unknown component for evaluate: ${component}`)
  }

  return dispatch
}

function sicpJsApply(fn, args) {
  if(isPrimitiveProcedure(fn))
    return applyPrimitiveProcedure(fn, args)
  if(isCompondProcedure(fn)) {
    const result = evalSequence(
      getProcedureBody(fn),
      extendEnvironment(
        getProcedureParameters(fn),
        args,
        getProcedureEnvironment(fn)
      )
    )

    return isReturnValue(result) ? returnValueContent(result) : undefined
  }

  throw new Error(`Unknown procedure type -- Apply: ${fn}`)
}

const evaluate = sicpJsEval()
const apply = sicpJsApply

// Procedure arguments
function listOfValues(exps, env) {
  return map(arg => evaluate(arg, env), exps)
}

// Conditionals
function evalIf(exp, env) {
  return isTruthy(evaluate(getIfPredicate(exp), env)) ?
    evaluate(getIfConsequent(exp), env) :
    evaluate(getIfAlternative(exp), env)
}

// Sequences
function evalSequence(exps, env) {
  if(isEmptySequence(exps))
    return undefined

  let result = evaluate(getFirstExp(exps), env)
  if(isLastExp(exps) || isReturnValue(result))
    return result

  return evalSequence(getRestExps(exps), env)
}

// Assignments and definitions
function evalAssignment(exp, env) {
  $setVariableValue(
    assignmentVariable(exp),
    evaluate(assignmentValue(exp), env),
    env
  )
}

function evalDefinition(exp, env) {
  $defineVariable(
    getDefinitionVariable(exp),
    evaluate(getDefinitionValue(exp), env),
    env
  )
}

const _table = new Map() // eslint-disable-line
// (symbol x) => x
_table.set(SYMBOL, exp => exp.getCadr())
_table.set(IF, exp => {
  let res = IF + '('

  res += unparse(getIfPredicate(exp))
  res += ') { '
  res += unparse(getIfConsequent(exp))
  res += ' } '

  if(getIfAlternative(exp)) {
    res += 'else { '
    res += unparse(getIfAlternative(exp))
    res += ' } '
  }

  return res
})

_table.set(SEQUENCE, exp => {
  let result = ''
  if(!isBegin(exp))
    throw new Error(`Unparse sequence ended with unSeq: ${exp}`)

  const seq = beginActions(exp)

  if(isEmptySequence(seq))
    return result

  result += unparse(getFirstExp(seq)) + '; '
  result += unparse(getRestExps(seq))

  return result
})

_table.set(ASSIGNMENT, exp => {

})

_table.set(LAMBDA, (exp, env) => makeProcedure(getLambdaParameters(exp), getLambdaBody(exp), env))
_table.set(BLOCK, (exp, env) => {})

function unparse(taggedList) {
  if(!isTaggedList(taggedList)) {
    if(isSelfEvaluating(taggedList)) {
      if(typeof taggedList === 'string')
        return `"${taggedList}"`
      return taggedList
    }

    throw new Error('not taggedList: ' + taggedList)
  }
  
  const tag = getTag(taggedList)
  const handler = _table.get(tag)

  if(typeof handler !== 'function')
    throw new Error(`cannot get unparse handler for tag: ${tag}`)

  return handler(taggedList)
}


module.exports = {
  sicpEval,
  sicpApply,
  evaluate,
  apply,
  unparse,
}
