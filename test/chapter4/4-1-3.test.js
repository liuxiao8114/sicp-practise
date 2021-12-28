const path = require('path')

const SRC_ROOT = `../../src/chapter4/`
const { car, cdr, pair, isNull, list, map } = require(path.join(SRC_ROOT, 'utils'))
const { evaluate } = require(path.join(SRC_ROOT, '4-1-1'))
const {
  isTaggedList,
  sicpIf,
  operatorCombinationToApplication,
  makeName,
  makeAssignment,
} = require(path.join(SRC_ROOT, '4-1-2'))
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
} = require(path.join(SRC_ROOT, '4-1-3'))

describe('chapter 4.1.3', () => {
  it('nothing to say yet', () => {
    
  })
})
