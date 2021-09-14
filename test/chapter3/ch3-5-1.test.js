const path = require('path')

const SRC_ROOT = `../../src/chapter3/`
const { isNull, car, pair, display } = require(path.join(SRC_ROOT, 'utils'))
const {
  sum_primes_i, sum_primes_j,
  memo,
  stream_cdr, stream_ref,
  stream_map, stream_enumerate_interval, stream_filter
} = require(path.join(SRC_ROOT, 'ch3-5-1'))

function sumFromTo(from, to, step = 1) {
  return new Array(
    Math.ceil(to / step) - Math.ceil(from / step) + 1
  ).fill(from).reduce((a, b, i) => a + (b + step * i), 0)
}

describe('chapter 3-5-1', () => {
  it('sum_primes', () => {
    const EXPECT = sumFromTo(2, 10, 2)

    expect(sum_primes_i(1, 10)).toBe(EXPECT)
    expect(sum_primes_j(1, 10)).toBe(EXPECT)
  })

  it('stream defination', () => {
    const enums = stream_enumerate_interval(1, 10)
    const filterEnums = stream_filter(x => x % 2 === 0, enums)
    expect(car(stream_cdr(enums))).toBe(2)
    expect(car(stream_cdr(stream_cdr(enums)))).toBe(3)
    expect(car(stream_cdr(filterEnums))).toBe(4)
  })
})

describe('chapter 3-5-1 exercises', () => {
  it('exec3.50', () => {
    function stream_map2(fn, s1, s2) {
      return pair(
        fn(car(s1), car(s2)),
        () => stream_map2(fn, stream_cdr(s1), stream_cdr(s2))
      )
    }

    const fn = (x, y) => x * y
    const s1 = stream_enumerate_interval(1, 10)
    const s2 = stream_enumerate_interval(3, 5)
    const seq = stream_map2(fn, s1, s2)

    expect(car(seq)).toBe(1 * 3)
    expect(car(stream_cdr(seq))).toBe(2 * 4)
    expect(car(stream_cdr(stream_cdr(seq)))).toBe(3 * 5)
  })

  it('exec3.51', () => {
    function stream_map_op(fn, s) {
      if(isNull(s))
        return null
      return pair(fn(car(s)), memo(() => stream_map_op(fn, stream_cdr(s))))
    }

    const list = stream_enumerate_interval(1, 10)

    let x = stream_map(display, list)
    console.log('5: ' + stream_ref(x, 5))
    console.log('7: ' + stream_ref(x, 7))

    console.log(`----------------------`)

    let y = stream_map_op(display, list)
    console.log('5: ' + stream_ref(y, 5))
    console.log('7: ' + stream_ref(y, 7))
  })

  it('exec3.52', () => {
    let sum = 0

    function accum(x) {
      sum = x + sum
      return sum
    }

    // 1, 3, 6, 10, 15...
    let seq = stream_map(accum, stream_enumerate_interval(1, 20))
    expect(sum).toBe(1)

    /*
    see what will happen on [sum] if we call some stream_ref() here:
      console.log(stream_ref(seq, 0)) //  1, currentSum = 1
      console.log(stream_ref(seq, 1)) //  nextSum: currentSum(is 1) + 2 = 3
      console.log(stream_ref(seq, 2)) //  nextSum: currentSum(is 3) + 2 + 3 = 8
      console.log(stream_ref(seq, 3)) //  nextSum: currentSum(is 8) + 2 + 3 + 4 = 17
      console.log(stream_ref(seq, 4)) //  nextSum: currentSum(is 17)+ 2 + 3 + 4 + 5 = 31

    equation:
      stream_ref(seq, 3)
      <=> stream_ref(stream_cdr(seq), 2)
      <=> stream_ref(stream_cdr(stream_cdr(seq)), 1)
      <=> stream_ref(stream_cdr(stream_cdr(stream_cdr(seq))), 0)
                        17           13        10
    */

    /*
      seq:            y:
        1,             stream_filter(fn, stream_cdr(seq))
        1 + 2 = 3,     stream_filter(fn, stream_cdr(stream_cdr(seq)))
        3 + 3 = 6,     pair(car(stream_cdr(stream_cdr(seq))), () => stream_filter(fn, stream_cdr(stream_cdr(stream_cdr(seq)))))
    */
    const y = stream_filter(x => x % 2 === 0, seq)
    expect(sum).toBe(6)

    /*
      seq:            z:
        1,
        6  + 2 = 8,
        8  + 3 = 11,
        11 + 4 = 15,
    */
    const z = stream_filter(x => x % 5 === 0, seq)
    expect(sum).toBe(15)

    /*
      seq:
        ...
        15 + 4 = 19,
        19 + 5 = 24,
        24 + 6 = 30,
    */
    expect(stream_ref(y, 2)).toBe(30)

    /*
      stream_ref(z, 3)
      <=> stream_ref(stream_cdr(z), 2)
      <=> stream_ref(streasm_cdr(stream_cdr(z)), 1)
      <=> stream_ref(streasm_cdr(streasm_cdr(stream_cdr(z))), 0)
                          75           65         35
      seq:
        ...
        30 +  5 = 35,
        35 +  6 = 41,
        41 +  7 = 48,
        48 +  8 = 56,
        56 +  9 = 65,
        65 + 10 = 75,
    */
    expect(stream_ref(z, 3)).toBe(75)

    sum = 0

    function stream_map_op(fn, s) {
      if(isNull(s))
        return null
      return pair(fn(car(s)), memo(() => stream_map_op(fn, stream_cdr(s))))
    }

    seq = stream_map_op(accum, stream_enumerate_interval(1, 20))
    expect(sum).toBe(1)

    /*
      seq:           memoY:
        1,              stream_filter(fn, stream_cdr(seq))
        1 + 2 = 3,      stream_filter(fn, stream_cdr(stream_cdr(seq)))
        3 + 3 = 6,      pair(car(stream_cdr(stream_cdr(seq))), () => stream_filter(fn, stream_cdr(stream_cdr(stream_cdr(seq)))))
    */
    const memoY = stream_filter(x => x % 2 === 0, seq)
    expect(sum).toBe(6)

    /*
      seq:            z:
        1,
        3,
        6,
        6 + 4 = 10,
    */
    const memoZ = stream_filter(x => x % 5 === 0, seq)
    expect(sum).toBe(10)

    /*
      seq:
        ...
        10
        10 + 5 = 15,
        15 + 6 = 21,
        21 + 7 = 28
    */
    expect(stream_ref(memoY, 2)).toBe(28)

    /*
      seq:
        ...
        28
        28 + 8 = 36,
        36 + 9 = 45,
    */
    expect(stream_ref(memoZ, 2)).toBe(45)
  })
})
