const utils = require('../utils')
const { isNull, pair, car, cdr } = utils

function map(fn, x) {
  if(isNull(x))
    return null
  return pair(fn(car(x)), map(fn, cdr(x)))
}

module.exports = {
  ...utils,
  map,
}
