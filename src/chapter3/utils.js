const { isPair, Cons, List } = require('../utils')

module.exports = {
  ...require('../utils'),
  car,
  cdr,
  isNull,
  pair,
  list,
}

function car(p) {
  if(!isPair(p))
    throw new Error(`car() needs a Cons instance param but got: ${p}, ${typeof p} instead.`)
  return p.car
}

function cdr(p) {
  if(!isPair(p))
    throw new Error(`cdr() needs a Cons instance param but got: ${p}, ${typeof p} instead.`)
  return p.cdr
}

function isNull(p) {
  return p == null || (isPair(p) && car(p) == null)
}

function pair(a, b) {
  return new Cons(a, b)
}

function list(...values) {
  return new List(...values)
}
