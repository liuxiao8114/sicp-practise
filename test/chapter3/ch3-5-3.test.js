const path = require('path')

const SRC_ROOT = `../../src/chapter3/`
const { isNull, car, pair } = require(path.join(SRC_ROOT, 'utils'))
const {
  sum_primes_i, sum_primes_j,
  memo,
  stream_cdr, stream_ref,
  stream_map, stream_enumerate_interval, stream_filter
} = require(path.join(SRC_ROOT, 'ch3-5-1'))

const {
  stream_scale, add_streams,
  stream_map2_memo,
} = require(path.join(SRC_ROOT, 'ch3-5-2'))

const {
  sqrt_stream, pi_summands, euler_transform
} = require(path.join(SRC_ROOT, 'ch3-5-3'))

const MAX = 10

function expectIteration(stream, expectList) {
  let next = stream

  expectList.forEach(item => {
    expect(car(next)).toBe(item)
    next = stream_cdr(next)
  })
}

function consoleLogIteration(stream, counter = MAX) {
  let next = stream,
      result = ``

  for(let i = 0; i < counter; i++) {
    result += `${i}: ${car(next)}\r\n`
    next = stream_cdr(next)
  }

  console.log(result)
}

describe('chapter 3-5-3', () => {
  it('sqrt_stream', () => {
    consoleLogIteration(sqrt_stream(2))
  })

  it('pi_summands and euler_transform', () => {
    function add_streams_memo(s1, s2) {
      return stream_map2_memo((x, y) => x + y, s1, s2)
    }

    function partial_sums2(stream) {
      return add_streams_memo(stream, pair(0, () => partial_sums2(stream)))
    }

    const pi_stream = stream_scale(partial_sums2(pi_summands(1)), 4)
    consoleLogIteration(pi_stream, 30)
    consoleLogIteration(euler_transform(pi_stream), 30)
  })
})
