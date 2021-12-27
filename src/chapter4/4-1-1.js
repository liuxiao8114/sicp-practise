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
  isBegin, beginActions, getFirstExp, getRestExps, isLastExp,
  isLambda, getLambdaParameters, getLambdaBody,
  isApplication, getOperator, getOperands,
} = require('./4-1-2.js')

const {
  // Test of predicates
  isTruthy, isFalsy,
  // Representing procedures
  isPrimitiveProcedure, applyPrimitiveProcedure,
  createProcedure, isCompondProcedure, getProcedureParameters, getProcedureBody, getProcedureEnvironment,
  // Operations on Evnvironments
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
    return createProcedure(
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
  _table.set(SEQUENCE, evalSequence)
  _table.set(ASSIGNMENT, evalAssignment)
  _table.set(LAMBDA, (exp, env) => createProcedure(getLambdaParameters(exp), getLambdaBody(exp), env))
  _table.set(BLOCK, (exp, env) => {

  })

  // _table.set(isVariable, (exp, env) => lookupVariableValue(exp, env))
  // _table.set(isIf, evalIf)
  // _table.set(isBegin, (exp, env) => evalSequence())
  // _table.set(isAssignment, evalAssignment)
  // _table.set(isLambda, (exp, env) => createProcedure(getLambdaParameters(exp), getLambdaBody(exp), env))

  function dispatch(component, env) {
    if(isTaggedList(component))
      return _table.get(car(component))(component, env)
    return component
  }

  return dispatch
}

const _table = new Map() // eslint-disable-line
_table.set(SYMBOL, )

function unparse(taggedList) {
  if(!isTaggedList(taggedList))
    throw new Error('not taggedList: ' + taggedList)

  _table.get(getTag(taggedList))

}

function sicpJsApply() {
  const _table = new Map() // eslint-disable-line

  function dispatch(component, env) {
    if(isTaggedList(component))
      return _table.get(car(component))(component, env)
    return component
  }

  return dispatch
}

const evaluate = sicpJsEval()
const apply = sicpJsApply()

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
  let result = evaluate(getFirstExp(exps), env)

  if(!isLastExp(exps))
    result = evalSequence(getRestExps(exps), env)

  return result
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

module.exports = {
  sicpEval,
  sicpApply,
  evaluate,
  apply,
}
