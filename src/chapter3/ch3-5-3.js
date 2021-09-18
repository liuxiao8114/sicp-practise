const { pair, car } = require('./utils')
const { stream_cdr, stream_filter, stream_map, stream_ref, memo } = require('./ch3-5-1')

function average(a, b) {
  return (a + b) / 2
}

function sqrt_improve(guess, x) {
  return average(guess, x / guess)
}

function sqrt_stream(x) {
  return pair(
    1,
    () => stream_map(guess => sqrt_improve(guess, x), sqrt_stream(x))
  )
}

function pi_summands(n) {
  return pair(1 / n, () => stream_map(x => -x, pi_summands(n + 2)))
}

function square(x) {
  return x * x
}

function euler_transform(s) {
  const s0 = stream_ref(s, 0)
  const s1 = stream_ref(s, 1)
  const s2 = stream_ref(s, 2)

  return pair(
    s2 - square(s2 - s1) / (s0 + (-2) * s1 + s2),
    memo(() => euler_transform(stream_cdr(s))))
}

module.exports = {
  sqrt_stream,
  pi_summands,
  euler_transform,
}
