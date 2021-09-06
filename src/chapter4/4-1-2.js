const { List, isPair } = require('./utils')

module.exports = {
  ...base,
  ...assignment,
  ...sicpIf,
  ...begin,
  ...lambda,
  ...definition,
}

const base = {
  isSelfEvaluating: exp => typeof exp === 'number' || typeof exp === 'string',
  isVariable: exp => base.isTaggedList(exp, 'symbol'),
  isTaggedList: (exp, tag) => isPair(exp) && exp.getCar() === tag,
  isQuoted: exp => base.isTaggedList(exp, 'quote'),
  getTextQuotation: exp => exp,
}

// Assignments
const assignment = {
  isAssignment(exp) {
    return base.isTaggedList(exp, 'set!')
  },
  assignmentVariable(exp) {
    return exp.getCadr(exp)
  },
  assignmentValue(exp) {
    return exp.getCaddr(exp)
  },
}

// If
const sicpIf = {
  evalIf: (predicate, consequent, alternative) => new List('if', predicate, consequent, alternative),
  isIf: exp => base.isTaggedList(exp, 'symbol'),
  getIfPredicate: exp => exp.getCadr(),
  getIfConsequent: exp => exp.getCddr().getCar(),
  getIfAlternative: exp => exp.getCddr().getCdr(),
}

// Sequences
const begin = {
  begin(seq) {
    return new List('begin', seq)
  },
  isBegin(exp) {
    return base.isTaggedList(exp, 'begin')
  },
  beginActions(exp) {
    return exp.getCdr()
  },
  getFirstExp(seq) {
    return seq.getCar()
  },
  getRestExps(seq) {
    return seq.getCdr()
  },
  isLastExp(seq) {
    return seq.getCdr() === null
  }
}

// Lambda
const lambda = {
  lambda(parameters, body) {
    return new List('lambda', parameters, body)
  },
  isLambda(exp) {
    return base.isTaggedList(exp, 'lambda')
  },
  getLambdaParameters(exp) {
    return exp.getCadr()
  },
  getLambdaBody(exp) {
    return exp.getCadr()
  },
}

// Definition
const definition = {
  isDefinition(exp) {
    return base.isTaggedList(exp, 'define')
  },
  getDefinitionVariable(exp) {
    if(base.isVariable(exp.getCadr()))
      return
  },
  getDefinitionValue: () => {},
}

// Application
const application = {
  isApplication(exp) {
    return isPair(exp)
  },
  getOperator(exp) {
    return exp.getCar()
  },
  getOperands(exp) {
    return exp.getCdr()
  },
  getFirstOperand(operands) {
    return operands.getCar()
  },
  getRestOperands(operands) {
    return operands.getCdr()
  },
  noOperands(operands) {
    return operands.getCdr()
  }
}

// Cond
const condition = {
  isCond(exp) {
    return base.isTaggedList(exp, 'cond')
  },
  getCondClauses(exp) {
    return exp.getCdr(exp)
  },
  isCondElse(clause) {

  },
  getCondPredicate(clause) {

  },
  getCondActions(clause) {

  },
  changeCondToIf(exp) {

  },

}
