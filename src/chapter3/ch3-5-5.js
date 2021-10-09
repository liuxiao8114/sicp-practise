const { pair, car } = require('./utils')
const { stream_cdr, stream_map, memo } = require('./ch3-5-1')

function gcd(a, b) {
  if(!a)
    return 0
  if(b < a)
    return gcd(b, a)
  return b % a === 0 ? a : gcd(b % a, a)
}

function random() {
  return Math.floor(Math.random() * 10000) + 1
}

const one = pair(1, () => one)
const random_numbers = stream_map(() => random(), one)

function map_successive_pairs(f, s) {
  return pair(
    f(car(s), car(stream_cdr(s))),
    memo(
      () => map_successive_pairs(f, stream_cdr(stream_cdr(s)))
    )
  )
}

const dirichlet_stream = map_successive_pairs(
  (r1, r2) => gcd(r1, r2) === 1, random_numbers)

function monte_carlo(experiment_stream, passed, failed) {
  function next(passed, failed) {
    return pair(
      passed / (passed + failed),
      memo(
        () => monte_carlo(stream_cdr(experiment_stream), passed, failed)
      )
    )
  }

  return car(experiment_stream) ? next(passed + 1, failed) : next(passed, failed + 1)
}

const pi = stream_map(p => Math.sqrt(6 / p), monte_carlo(dirichlet_stream, 0, 0))

// A functional-programming view of time
function stream_withdraw(balance, amount_stream) {
  return pair(
    balance,
    () => stream_withdraw(balance - car(amount_stream), stream_cdr(amount_stream))
  )
}

module.exports = {
  gcd,
  pi
}
