// 4.1.1 The core of the evaluator
// some parts are implemented in the fellow
const {
  isVariable,
  isSelfEvaluating,
  isQuoted, getTextQuotation,
  isDefinition,
  isAssignment, assignmentVariable, assignmentValue,
  isIf, getIfPredicate, getIfConsequent, getIfAlternative,
  isBegin, beginActions, getFirstExp, getRestExps, isLastExp,
  isLambda, getLambdaParameters, getLambdaBody,
  isApplication, getOperator, getOperands,
} = require('./4-1-2.js')

const {
  // Representing procedures
  isPrimitiveProcedure, applyPrimitiveProcedure,
  createProcedure, isCompondProcedure, getProcedureParameters, getProcedureBody, getProcedureEnvironment,
  // Operations on Evnvironments
  lookupVariableValue, extendEnvironment, $defineVariable, $setVariableValue,
} = require('./4-1-3.js')

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
      listofValues(getOperands(exp), env)
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

// Procedure arguments
function listofValues(exps, env) {

}

// Conditionals
function evalIf(exp, env) {
  return sicpEval(getIfPredicate(exp), env) ?
    sicpEval(getIfConsequent(exp), env)
    : sicpEval(getIfAlternative(exp), env)
}

// Sequences
function evalSequence(exps, env) {
  sicpEval(getFirstExp(exps), env)

  if(!isLastExp(exps)) {
    return evalSequence(getRestExps(exps), env)
  }
}

// Assignments and definitions
function evalAssignment(exp, env) {
  $setVariableValue(
    assignmentVariable(exp),
    sicpEval(assignmentValue(exp), env),
    env
  )
}

function evalDefinition(exp, env) {

}
