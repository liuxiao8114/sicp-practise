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
    return createProcedure(getLambdaParameters(exp), getLambdaBody(exp), env)
  else if(isBegin(exp))
    return evalSequence(beginActions(exp), env)
  else if(isApplication(exp)) {
    return sicpApply(
      sicpEval(getOperator(exp), env),
      listValues(getOperands(exp), env)
    )
  }
}

function sicpApply(procedure, args) {
  if(isPrimitiveProcedure(procedure))
    return applyPrimitiveProcedure(procedure, args)
  if(isCompondProcedure(procedure))
    return
}

// Conditionals
function evalIf(exp, env) {
  if(!!sicpEval(ifPredicate(exp), env))
    sicpEval(ifConsequent(exp), env)
  else
    sicpEval(ifAlternative(exp), env)
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

}

function evalDefinition(exp, env) {

}

function listValues(exp, env) {
  return
} 
