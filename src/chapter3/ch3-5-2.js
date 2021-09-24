const { pair, car, square } = require('./utils')
const { stream_cdr, stream_filter, stream_map, memo } = require('./ch3-5-1')

function integersStartingFrom(n) {
  return pair(n, () => integersStartingFrom(n + 1))
}

function isDivisible(x, y) {
  return x % y === 0
}

// 1, 1, 2, 3, 5, 8, 13, 21...
/*
a: 1  1  2  3   5   8  13  21
b: 1  2  3  5   8  13  21  34
f: 2  3  5  8  13  21  34  55
*/
function fibgen(a = 0, b = 1) {
  return pair(a, () => fibgen(b, a + b))
}

// Defining streams implicitly
const ones = pair(1, () => ones)

function stream_map2(fn, s1, s2) {
  return pair(
    fn(car(s1), car(s2)),
    () => stream_map2(fn, stream_cdr(s1), stream_cdr(s2))
  )
}

function stream_map2_memo(fn, s1, s2) {
  return pair(
    fn(car(s1), car(s2)),
    memo(() => stream_map2_memo(fn, stream_cdr(s1), stream_cdr(s2)))
  )
}

function add_streams(s1, s2) {
  return stream_map2((x, y) => x + y, s1, s2)
}

const integers = pair(1, () => add_streams(integers, ones))
const integersMemo = pair(1, memo(() => stream_map2_memo((x, y) => x + y, integers, ones)))
/*
  add_stream(integers, ones)
  <=> stream_map2((x, y) => x + y, integers, ones)
  <=> pair(
        car(integers) + car(ones),
        () => stream_map2((x, y) => x + y, stream_cdr(integers), stream_cdr(ones))
      )
*/

const fibs = pair(0, () => pair(1, () => add_streams(fibs, stream_cdr(fibs))))

function stream_scale(stream, factor) {
  return stream_map(x => factor * x, stream)
}

const double = pair(1, () => stream_scale(double, 2))

const primes = pair(2, () => stream_filter(isPrime, integersStartingFrom(3)))

function isPrime(n) {
  function iter(ps) {
    return square(car(ps)) > n ?
      true : isDivisible(n, car(ps)) ?
      false : iter(stream_cdr(ps))
  }

  return iter(primes)
}

module.exports = {
  integersStartingFrom,
  isDivisible,
  stream_scale,
  stream_map2,
  stream_map2_memo,
  add_streams,
  fibgen,
  integers,
  integersMemo,
  fibs,
  ones,
  double,
  primes,
}

// const { pairs } = require('./ch3-5-3')
// function triples(s, t, u) {
//   return stream_filter(
//     x => square(x.car.car) + square(x.car.cdr.car) === square(x.cdr.car),
//     pairs(pairs(s, t), u)
//   )
// }
//
// const s = triples(integersMemo, integersMemo, integersMemo)
//
// stream_cdr(s)

/*
$(item:"requestName")$(item:"year")年$(item:"month")月分
output\作業時間集計表_$(item:"year")年$(item:"month")月分_$(item:"requestName")様_$(item:"projectId")_$(val:SYS_DATE_TXT)$(val:SYS_TIME_TXT).xlsx

*/
