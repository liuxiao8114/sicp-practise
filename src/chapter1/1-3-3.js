module.exports = {
  search,
  fixPoint,
  sqrt,
  fixPointAsRtn
}

function search(f, neg, pos) {
  let mid = Math.floor((neg + pos) / 2)
  let tryOnce = f(mid)

  if(isEnough(tryOnce))
    return mid
  else if(tryOnce > 0)
    return search(f, neg, mid)
  else if(tryOnce < 0)
    return search(f, mid, pos)
}

function isEnough(tryOnce) {
  return Math.abs(tryOnce) <= 0.00001
}

function halfInterval(neg, pos) {
  return f => search(f, neg, pos)
}

const TOLERANCE = 0.000001

function isEnoughV2(v1, v2) {
  return Math.abs(v1 - v2) < TOLERANCE
}

function fixPoint(f, init) {
  function tryOne(guess) {
    let next = f(guess)
    if(isEnoughV2(guess, next)) {
      return next
    }
    return tryOne(next)
  }

  return tryOne(init)
}

function fixPointAsRtn(init) {
  return f => f(init)
}

function average(a, b) {
  return (a + b) / 2
}

function damping(f) {
  return x => average(x, f(x))
}

function sqrt(x) {
  return fixPoint(damping(y => x / y), 1.0)
}
