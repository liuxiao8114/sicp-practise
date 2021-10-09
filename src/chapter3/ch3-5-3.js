const { pair, car, square } = require('./utils')
const { stream_cdr, stream_map, stream_ref, memo } = require('./ch3-5-1')

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

/*
  pair(1, () => stream_map(x => -x, pi_summands(3)))
  pair(1, () => stream_map(x => -x,
      pair(3, () => stream_map(x => -x, pi_summands(5)))))
  pair(1, () => stream_map(x => -x,
      pair(3, () => stream_map(x => -x,
          pair(5, () => stream_map(x => -x, pi_summands(7))))))
*/

function euler_transform(s) {
  const s0 = stream_ref(s, 0)
  const s1 = stream_ref(s, 1)
  const s2 = stream_ref(s, 2)

  return pair(
    s2 - square(s2 - s1) / (s0 + (-2) * s1 + s2),
    memo(() => euler_transform(stream_cdr(s))))
}

function make_tableau(transform, s) {
  return pair(s, () => make_tableau(transform, transform(s)))
}

function accelerated_sequence(transform, s) {
  return stream_map(car, make_tableau(transform, s))
}

// Infinite streams of pairs
const { isNull, list } = require('./utils')

function stream_map_memo(fn, s) {
  return pair(fn(car(s)), memo(() => stream_map_memo(fn, stream_cdr(s))))
}

function pairs(s, t) {
  return pair(
    list(car(s), car(t)),
    memo(
      () => interleave(
        stream_map_memo(x => list(car(s), x), stream_cdr(t)),
        pairs(stream_cdr(s), stream_cdr(t))
      )
    )
  )
}

function interleave(s1, s2) {
  return isNull(s1) ? s2 : pair(
    car(s1), () => interleave(s2, stream_cdr(s1))
  )
}

// Streams as signals
const { add_streams, stream_scale } = require('./ch3-5-2')
function integral(integrand, inital_value, dt) {
  const integ = pair(
    inital_value,
    () => add_streams(stream_scale(integrand, dt), integ)
  )

  return integ
}

module.exports = {
  sqrt_stream,
  pi_summands,
  euler_transform,
  accelerated_sequence,
  pairs,
  interleave,
  integral,
}
