const { Cons, list, isPair } = require('./utils')

function isSelfEvaluating(exp) {
  return typeof exp === 'number' || typeof exp === 'string'
}

function isTaggedList(exp, tag) {
  return isPair(exp) && exp.getCar() === tag
}

function isVariable(exp) {
  return isTaggedList(exp, 'symbol')
}

function isQuoted(exp) {
  return isTaggedList(exp, 'quote')
}

function isAssignment(exp) {
  return isTaggedList(exp, 'set!')
}

function isLambda(exp) {
  return isTaggedList(exp, 'lambda')
}

function lambda(parameters, body) {
  return list('lambda', parameters, body)
}

function getLambdaParameters(exp) {
  return isLambda(exp) && exp.getCadr()
}

function getLambdaBody(exp) {
  return isLambda(exp) && exp.getCadr()
}

function isDefinition(exp) {
  return isTaggedList(exp, 'define')
}

function getDefinitionVariable(exp) {
  if(isVariable(exp.getCadr()))
    return
}

function getDefinitionValue() {
  
}

module.exports = {
  isSelfEvaluating,
  isVariable,
  isQuoted,
  isAssignment,
  isTaggedList,
  isLambda,
  getLambdaParameters,
  getLambdaBody
}
