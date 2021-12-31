// 4.1.2 Representing Expressions/Components
const { Cons, List, isPair, isNull } = require('./utils')
// const { evaluate, apply } = require('./4-1-1')

const SYMBOL = 'symbol'
const IF = 'if'
const SEQUENCE = 'begin'
const ASSIGNMENT = 'set!'
const LAMBDA = 'lambda'
const COND = 'cond'
const DEFINE = 'define'

let TAGS = { SYMBOL, IF, SEQUENCE, ASSIGNMENT, LAMBDA, COND }

/*
  Literal expression: list('literal', value)
  Names: list('name', symbol)
  Expression statements: <exp>
  Function application: <fun-exp(arg-exp1, arg-exp2...)> =>list('application', <fun-exp>, list(<arg-exp1>, <arg-exp2>, ...))
  Conditionals:
*/
const base = {
  isSelfEvaluating: exp => isNull(exp) || typeof exp === 'number' || typeof exp === 'string',
  isTaggedList(exp, tag) {
    if(!isPair(exp))
      return false
    if(typeof tag === 'string')
      return exp.getCar() === tag
    if(Array.isArray(tag))
      return tag.includes(exp.getCar())
    if(tag == null)
      return Object.values(TAGS).includes(exp.getCar())

    throw new Error(`Unknown type for exp: ${exp}, tag: ${tag}.`)
  },
  isQuoted: exp => base.isTaggedList(exp, 'quote'),
  getTextQuotation: exp => exp,
  getTag(exp) {
    if(!base.isTaggedList(exp))
      throw new Error('Cannot getTag from a unTagged list or other component.')
    return exp.getCar()
  }
}

// Names / Variables
const variable = {
  makeVariable: name => new List(SYMBOL, name),
  makeName: name => new List(SYMBOL, name),
  isVariable: exp => base.isTaggedList(exp, SYMBOL),
}

// Assignments
// (ASSIGNMENT (SYMBOL x) 1)
const assignment = {
  makeAssignment(variable, value) {
    return new List(ASSIGNMENT, variable, value)
  },
  isAssignment(exp) {
    return base.isTaggedList(exp, ASSIGNMENT)
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
  makeIf: (predicate, consequent, alternative = null) => new List(IF, predicate, consequent, alternative),
  isIf: exp => base.isTaggedList(exp, IF),
  getIfPredicate: exp => exp.getCadr(),
  getIfConsequent: exp => exp.getCaddr(),
  getIfAlternative: exp => isPair(exp.getCdddr()) ? exp.getCdddr().getCar() : false,
}

// Sequences
const begin = {
  makeBegin(seq) {
    return new Cons(SEQUENCE, seq)
  },
  isBegin(exp) {
    return base.isTaggedList(exp, SEQUENCE)
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
  },
  sequenceToExp(seq) {

  }
}

// Lambda
// js-spec
const lambda = {
  makeLambda(parameters, body) {
    return new List(LAMBDA, parameters, body)
  },
  isLambda(exp) {
    return base.isTaggedList(exp, LAMBDA)
  },
  getLambdaParameters(exp) {
    return exp.getCadr()
  },
  getLambdaBody(exp) {
    return exp.getCddr()
  },
}

// Definition / Declaration
const definition = {
  isDefinition(exp) {
    return base.isTaggedList(exp, DEFINE)
  },
  getDefinitionVariable(exp) {
    if(variable.isVariable(exp.getCadr()))
      return exp.getCadr()
    return exp.getCaadr()
  },
  getDefinitionValue(exp) {
    //case: (define var value)
    if(variable.isVariable(exp.getCaddr()))
      return exp.getCaddr()
    //case: (define (var parameter1 … parameterN) body) <=> (define var (lambda (parameter1 … parameterN) body))
    return lambda.makeLambda(exp.getCdadr(), exp.getCddr())
  },
}

/*
  Application
  As js-spec Function applications needs an explict constructor described later,
  they should have different treatments in some methods like isApplication(), getOperator() and getOperands().
*/
const application = {
  isApplication(exp) {
    return base.isTaggedList(exp, APPLICATION) || (!base.isTaggedList(exp) && isPair(exp))
  },
  getOperator(exp) {
    return base.isTaggedList(exp, APPLICATION) ? exp.getCadr() : exp.getCar()
  },
  getOperands(exp) {
    return base.isTaggedList(exp, APPLICATION) ? exp.getCddr() : exp.getCdr()
  },
  getFirstOperand(operands) {
    if(!isPair(operands))
      return null
    return operands.getCar()
  },
  getRestOperands(operands) {
    if(!isPair(operands))
      return null
    return operands.getCdr()
  },
  noOperands(operands) {
    return operands.getCdr()
  }
}

/*
  JavaScript spec
*/
const LITERAL = 'literal'
const APPLICATION = 'application'
const DECLARATION = 'declaration'
const FUNCTION_DECLARATION = 'function'
const VARIABLE_DECLARATION = 'var'
const CONSTANT_DECLARATION = 'const'

const BLOCK = 'block'
const RETURN = 'return'

const JS_TAGS = {
  LITERAL, BLOCK, RETURN, APPLICATION,
  FUNCTION_DECLARATION, VARIABLE_DECLARATION, CONSTANT_DECLARATION,
}

TAGS = { ...TAGS, ...JS_TAGS }

const BINARY_OPERATORS = /[+\-*/]|={1,3}/
const UNARY_OPERATORS = /[!~]/

const jsSpec = {
  // Literal
  ...{
    makeLiteral: component => new List(LITERAL, component),
    isLiteral: component => base.isTaggedList(component, LITERAL) || base.isSelfEvaluating(component),
    literalValue: component => base.isTaggedList(component, LITERAL) ? component.getCadr() : component,
  },

  /*
    Function applications
    In SICP written by Scheme, the procedure application is any compound expression that is not
    the case above. But in JavaScript version, the isApplication if-branch is comming quite before that
    we need an explict constructor to define(or tag) it.
  */
  ...{
    makeApplication(functionExp, ...argumentExps) {
      return new List(APPLICATION, functionExp, ...argumentExps)
    },
  },

  // Sequences
  ...{
    isEmptySequence: seq => isNull(seq)
  },

  // Blocks
  ...{
    makeBlock: statement => new List(BLOCK, statement),
    isBlock: component => base.isTaggedList(component, BLOCK),
  },

  // Return statements
  ...{
    makeReturn: statement => new List(RETURN, statement),
    isReturn: component => base.isTaggedList(component, RETURN),
  },

  // Constant, variable, and function declarations
  ...{
    makeConstantDeclaration: (name, valueExpression) => new List(CONSTANT_DECLARATION, name, valueExpression),
    declarationSymbol: component => component.getCadr(),
    declarationValueExpression: component => component.getCaddr(),

    // FUNCTION <NAME>(...PARAMETERS) (BODY)
    isFnDeclaration: component => base.isTaggedList(component, FUNCTION_DECLARATION),
    fnDeclName: component => jsSpec.declarationSymbol(component),
    fnDeclParameters: component => component.getCaddr(),
    fnDeclBody: component => component.getCadddr(),

    // TODO:
    fnDeclToConstantDecl(component) {
      return jsSpec.makeConstantDeclaration(
        jsSpec.fnDeclName(component),
        jsSpec.makeLambda(jsSpec.fnDeclParameters(component), jsSpec.fnDeclBody(component))
      )
    },
    isDeclaration(component) {
      return base.isTaggedList(
        component,
        [ FUNCTION_DECLARATION, VARIABLE_DECLARATION, CONSTANT_DECLARATION, DECLARATION ]
      )
    },
  },
}

// Derived expressions
// Cond
const condition = {
  isCond(exp) {
    return base.isTaggedList(exp, COND)
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

/*
  We have to distinguish unary, binary operators.
  unary: !x,
*/
function isUnaryOperatorCombination(component) {
  const match = component.getCar().match(UNARY_OPERATORS)
  return match && match[0]
}

function isBinaryOperatorCombination(component) {
  const match = component.getCar().match(BINARY_OPERATORS)
  return match && match[0]
}

// This is a js-spec derived exp to convert exps like: x * y or !x to application.
function getJSFirstOperand(exp) {
  return exp.getCadr()
}

function getJSSecondOperand(exp) {
  return exp.getCaddr()
}

function operatorCombinationToApplication(component) {
  if(!isPair(component))
    throw new Error(`component is not a list: ${component}`)

  let operator = isUnaryOperatorCombination(component)

  if(operator)
    return jsSpec.makeApplication(
      variable.makeVariable(operator),
      getJSFirstOperand(component)
    )

  operator = isBinaryOperatorCombination(component)
  if(operator)
    return jsSpec.makeApplication(
      variable.makeVariable(operator),
      getJSFirstOperand(component),
      getJSSecondOperand(component)
    )

  throw new Error('Unknown Operator in component: ' + component)
}

function parse(statement) {

}

parse("const size = 2; 5 * size;")
const { list } = require('./utils')

list(
  "sequence",
  list(
    list(
      "constant_declaration",
      list("name", "size"),
      list("literal", 2)
    ),
    list("binary_operator_combination", "*", list("literal", 5), list("name", "size"))
  )
)

module.exports = {
  ...TAGS, TAGS,
  ...base, base,
  ...variable, variable,
  ...assignment, assignment,
  ...sicpIf, sicpIf,
  ...begin, begin,
  ...lambda,
  ...definition,
  ...application, application,
  ...jsSpec, jsSpec,
  isUnaryOperatorCombination,
  isBinaryOperatorCombination,
  operatorCombinationToApplication,
}
