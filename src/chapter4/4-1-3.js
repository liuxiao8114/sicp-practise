// 4.1.3 Evaluator Data Structions
const { Cons, List, isPair } = require('./utils')

// Test of predicates
function isTruthy(x) {
  return !!x
}

function isFalsy(x) {
  return !x
}

// Representing procedures
function applyPrimitiveProcedure() {

}

const frame = {
  createFrame(variables, values) {
    return new Cons(variables, values)
  },
  getFrameVariables(frame) {
    return frame.getCar()
  },
  getFrameValues(frame) {
    return frame.getCdr()
  },
  $bindingToFrame(variable, value, frame) {
    frame.setCar(new Cons(variable, frame.getCar()))
    frame.setCdr(new Cons(value, frame.getCdr()))
    return frame
  },
}

function extendEnvironment(variables, values, env) {
  if(variables.length === values.length)
    new Cons(frame.createFrame(variables, values), env)
  else if(variables.length < values.length)
    throw new Error(`"Too many arguments supplied" ${variables}, ${values}`)
  else
    throw new Error(`"Too few arguments supplied" ${variables}, ${values}`)
}

function lookupVariableValue(variable, env) {
  function loop(env) {
    function scan(variables, values) {

    }
  }

  return loop(env)
}

function $setVariableValue(variable, value, env) {

}

function $defineVariable() {

}

module.exports = {
  ...frame,
  isTruthy,
  isFalsy,
  extendEnvironment,
  lookupVariableValue,
  $setVariableValue,
  $defineVariable,
}
