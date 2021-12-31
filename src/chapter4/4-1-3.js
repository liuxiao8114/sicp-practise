// 4.1.3 Evaluator Data Structions
const { Cons, List, isNull } = require('./utils')

const {
  isTaggedList,
} = require('./4-1-2.js')

// Test of predicates
function isTruthy(x) {
  return !!x
}

function isFalsy(x) {
  return !x
}

// Representing procedures
const PROCEDURE = 'procedure'

const procedure = {
  makeProcedure(params, body, env) {
    return new List(PROCEDURE, params, body, env)
  },
  isCompondProcedure(fn) {
    return isTaggedList(fn, PROCEDURE)
  },
  applyPrimitiveProcedure(fn, args) {

  },
  isPrimitiveProcedure(fn) {

  },
}

// Representing return values
// ...

// Operations on Environments
const THE_EMPTY_ENVIRONMENT = null

const frame = {
  makeFrame(variables, values) {
    return new Cons(variables, values)
  },
  getFrameVariables(f) {
    return f.getCar()
  },
  getFrameValues(f) {
    return f.getCdr()
  },
  $bindingToFrame(variable, value, f) {
    f.setCar(new Cons(variable, f.getCar()))
    f.setCdr(new Cons(value, f.getCdr()))
    return f
  },
  getFirstFrame(env) {
    return env.getCar()
  },
  enclosingEnvironment(env) {
    return env.getCdr()
  },
  extendEnvironment(variables, values, env) {
    if(variables.length === values.length)
      return new Cons(frame.makeFrame(variables, values), env)
    if(variables.length < values.length)
      throw new Error(`"Too many arguments supplied" ${variables}, ${values}`)
    else
      throw new Error(`"Too few arguments supplied" ${variables}, ${values}`)
  },
  lookupVariableValue(variable, env) {
    function loop(env) {
      function scan(variables, values) {
        return isNull(variables) ?
          loop(frame.enclosingEnvironment(env)) :
          variable === variables.getCar() ?
          values.getCar() :
          scan(variables.getCdr(), values.getCdr())
      }

      if(env === THE_EMPTY_ENVIRONMENT)
        throw new Error(`Unbound variable: ${variable}`)

      let f = frame.getFirstFrame(env)
      return scan(frame.getFrameVariables(f), frame.getFrameValues(f))
    }

    return loop(env)
  },
  $setVariableValue(variable, value, env) {
    function loop(env) {
      function scan(variables, values) {
        return isNull(variables) ?
          loop(frame.enclosingEnvironment(env)) :
          variable === variables.getCar() ?
          values.setCar(value) :
          scan(variables.getCdr(), values.getCdr())
      }

      if(env === THE_EMPTY_ENVIRONMENT)
        throw new Error(`Unbound variable: ${variable}`)

      let f = frame.getFirstFrame(env)
      return scan(frame.getFrameVariables(f), frame.getFrameValues(f))
    }

    return loop(env)
  },
  $defineVariable(variable, value, env) {
    function scan(variables, values) {
      return isNull(variables) ?
        frame.$bindingToFrame(variable, value, env) :
        variable === variables.getCar() ?
        values.setCar(value) :
        scan(variables.getCdr(), values.getCdr())
    }

    let f = frame.getFirstFrame(env)
    return scan(frame.getFrameVariables(f), frame.getFrameValues(f))
  }
}

const jsSpec = {

}

module.exports = {
  isTruthy,
  isFalsy,
  ...procedure,
  ...frame, frame,
}
