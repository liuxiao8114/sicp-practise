function isSelfEvaluating(exp) {
  return typeof exp === 'number' || typeof exp === 'string'
}

function isVariable(exp) {

}

function isQuoted(exp) {

}

function isAssignment(exp) {

}

function taggedList(exp, tag) {

}

module.exports = {
  isSelfEvaluating,
  isVariable,
  isQuoted,
  isAssignment,
  taggedList,
}
