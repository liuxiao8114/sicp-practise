const { pair, car, cdr, isNull, display } = require('./utils')

module.exports = {
  sum_primes_i,
  sum_primes_j,
  memo,
  stream_cdr,
  stream_ref,
  stream_enumerate_interval,
  stream_filter,
  stream_map,
  stream_forEach,
  stream_display,
}

function sum_primes_i(a, b) {
  function iter(count, accum) {
    return count > b
      ? accum
      : is_prime(count)
      ? iter(count + 1, count + accum)
      : iter(count + 1, accum)
  }

  return iter(a, 0)
}

function sum_primes_j(a, b) {
  return accumulate((x, y) => x + y, 0, filter(is_prime, enumerate_interval(a, b)))
}

function is_prime(x) {
  return x % 2 === 0
}

function accumulate(fn, initial, candicates) {
  // console.log('accumulate candicates tostring: ' + candicates.toString())
  function iter(next, result) {
    if(isNull(next))
      return result
    return iter(next.cdr, fn(next.car, result))
  }

  return iter(candicates, initial)
}

function filter(fn, candicates) {
  // console.log('filter candicates tostring: ' + (candicates && candicates.toString()))
  if(isNull(candicates))
    return null
  if(fn(car(candicates)))
    return pair(car(candicates), filter(fn, cdr(candicates)))
  return filter(fn, cdr(candicates))
}

function enumerate_interval(from, to) {
  if(from > to)
    return null
  return pair(from, enumerate_interval(from + 1, to))
}

function stream_cdr(stream) {
  return cdr(stream)()
}

function stream_ref(s, n) {
  return n === 0 ?
    car(s) : stream_ref(stream_cdr(s), n - 1)
}

function stream_map(fn, s) {
  if(isNull(s))
    return null
  return pair(fn(car(s)), () => stream_map(fn, stream_cdr(s)))
}

function stream_forEach(fn, s) {
  if(isNull(s))
    return null
  else {
    fn(car(s))
    return stream_forEach(fn, stream_cdr(s))
  }
}

function stream_display(s) {
  return stream_forEach(display, s)
}

function stream_enumerate_interval(from, to) {
  return from > to ? null : pair(from, () => stream_enumerate_interval(from + 1, to))
}

function stream_filter(fn, candicates) {
  if(isNull(candicates))
    return null
  if(fn(car(candicates)))
    return pair(car(candicates), () => stream_filter(fn, stream_cdr(candicates)))
  return stream_filter(fn, stream_cdr(candicates))
}

function memo(fn) {
  let result = null
  return (...args) => {
    if(result === null || args.length > 0)
      result = fn(...args)
    return result
  }
}
