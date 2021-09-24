const path = require('path')

const SRC_ROOT = `../../src/chapter3/`
const { isNull, car, pair } = require(path.join(SRC_ROOT, 'utils'))

const {
  stream_cdr, stream_ref, stream_filter, stream_map,
  memo
} = require(path.join(SRC_ROOT, 'ch3-5-1'))

const {
  integersStartingFrom, isDivisible, fibgen,
  stream_map2, stream_map2_memo, stream_scale, add_streams,
  integers, fibs, double, primes,
} = require(path.join(SRC_ROOT, 'ch3-5-2'))

const EXPECT_FIBS = [ 0, 1, 1, 2, 3, 5, 8, 13, 21 ]
const EXPECT_PRIMES = [ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31 ]
const MAX = 10
const TO_FIXED = 5

function expectIteration(stream, expectList) {
  let next = stream

  expectList.forEach(item => {
    expect(car(next)).toBe(item)
    next = stream_cdr(next)
  })
}

function consoleLogIteration(stream, counter = TO_FIXED) {
  let next = stream,
      result = ``

  for(let i = 0; i < counter; i++) {
    result += `${i}: ${car(next)}\r\n`
    next = stream_cdr(next)
  }

  console.log(result)
}

describe('ch3-5-2 explict test cases', () => {
  it('noSevens', () => {
    const integers = integersStartingFrom(1)
    const noSevens = stream_filter(x => !isDivisible(x, 7), integers)

    expect(stream_ref(noSevens, 100)).toBe(117)
  })

  it('sieve', () => {
    function sieve(stream) {
      const carStream = car(stream)
      return pair(
        carStream,
        () => sieve(
          stream_filter(x => !isDivisible(x, carStream), stream_cdr(stream))
        )
      )
    }

    const primes = sieve(integersStartingFrom(2))
    expect(stream_ref(primes, 50)).toBe(233)
  })

  it('fibgen', () => {
    expectIteration(fibgen(), EXPECT_FIBS)
  })
})

describe('ch3-5-2 implicit stream test cases', () => {
  it('integers', () => {
    expectIteration(integers, new Array(MAX).fill(1).map((x, i) => i + 1))
  })

  it('double', () => {
    expectIteration(double, new Array(MAX).fill(1).map((x, i) => 1 << i))
  })

  it('fibs', () => {
    expectIteration(fibs, EXPECT_FIBS)
  })

  it('primes', () => {
    expectIteration(primes, EXPECT_PRIMES)
  })
})

describe('chapter 3-5-2 exercises', () => {
  function partial_sums(stream) {
    function iter(sum, s) {
      return pair(
        sum + car(s),
        () => iter(sum + car(s), stream_cdr(s))
      )
    }

    return iter(0, stream)
  }

  it('exec3.53', () => {
    const s = pair(1, () => add_streams(s, s)) //  worked same as double
  })

  it('exec3.54', () => {
    function mul_streams(s1, s2) {
      return stream_map2((x, y) => x * y, s1, s2)
    }

    const factorials = pair(1, () => mul_streams(integers, factorials))

    let result = 1
    expectIteration(
      factorials,
      new Array(MAX).fill(1).map(
        (x, i) => {
          if(i !== 0)
            result *= i
          return result
        }
      )
    )
  })

  it('exec3.55', () => {
    const psIntegers = partial_sums(integers)

    let next = psIntegers,
        expectResult = 0

    for(let i = 1; i < MAX; i++) {
      expectResult += i
      expect(car(next)).toBe(expectResult)
      next = stream_cdr(next)
    }

    const psPrimes = partial_sums(primes)
    next = psPrimes,
    expectResult = 0

    for(let i = 0; i < MAX; i++) {
      expectResult += EXPECT_PRIMES[i]
      expect(car(next)).toBe(expectResult)
      next = stream_cdr(next)
    }
  })

  it('exec3.56', () => {
    function merge(s1, s2) {
      if(isNull(s1))
        return () => s2
      if(isNull(s2))
        return () => s1

      const car1 = car(s1)
      const car2 = car(s2)

      if(car1 < car2)
        return pair(car1, () => merge(stream_cdr(s1), s2))
      else if(car1 > car2)
        return pair(car2, () => merge(s1, stream_cdr(s2)))
      return pair(car1, () => merge(stream_cdr(s1), stream_cdr(s2)))
    }

    const s = pair(1,
      () => merge(merge(stream_scale(s, 2), stream_scale(s, 3)), stream_scale(s, 5)))

    const EXPECT_RESULTS = [ 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24, 25, 27 ]
    expectIteration(s, EXPECT_RESULTS)
  })

  it('exec3.57', () => {
    let calledCounter = 0,
        next = null

    function add_streams(s1, s2) {
      return stream_map2(fnCounter((x, y) => x + y), s1, s2)
    }

    function add_streams_memo(s1, s2) {
      return stream_map2_memo(fnCounter((x, y) => x + y), s1, s2)
    }

    function fnCounter(fn) {
      return (...args) => {
        ++calledCounter
        return fn(...args)
      }
    }

    const noMemoFibs = pair(
      0,
      () => pair(
        1,
        () => add_streams(noMemoFibs, stream_cdr(noMemoFibs))))

    next = noMemoFibs
    for(let i = 0; i < 6; i++)
      next = stream_cdr(next)

    expect(calledCounter).toBe(26)
    /*
      i < 0: 0
      i < 1: 0
      i < 2: 1
      i < 3: last(1) + current(1 + 1) = 3
      i < 4: last(3) + current(1 + 2 + 1) = 7
      i < 5: last(7) + current(1 + 4 + 2) = 14
      i < 6: last(14) + current(1 + 7 + 4) = 26
      i < 7: last(26) + current(1 + 12 + 7) = 46
    */

    calledCounter = 0
    const memoFibs = pair(
      0,
      memo(
        () => pair(
          1,
          memo(
            () => add_streams_memo(memoFibs, stream_cdr(memoFibs))))))
    next = memoFibs
    for(let i = 0; i < 20; i++)
      next = stream_cdr(next)

    expect(calledCounter).toBe(19)
  })

  it('exec3.58', () => {
    function math_trunc(x) {
      return Math.floor(x)
    }

    function expand(a, b, radix) {
      return pair(
        math_trunc((a * radix) / b),
        () => expand((a * radix) % b, b, radix))
    }

    expectIteration(expand(1, 7, 10), [ 1, 4, 2, 8, 5, 7, 1, 4 ])
    expectIteration(expand(3, 8, 10), [ 3, 7, 5, 0, 0, 0, 0, 0 ])
  })

  it('exec3.59, 3.60', () => {
    function integrate_series(stream) {
      return stream_map(x => 1/x, stream)
    }

    // a.
    const C = 10
    const one_series = pair(C, () => integrate_series(integers))
    // consoleLogIteration(one_series)

    // b.
    const exp_series = pair(1, () => integrate_series(exp_series))
    const cosine_series = pair(1, () => stream_map(x => x%2 === 1?0:1, integrate_series(cosine_series)))
    const sine_series = pair(0, () => stream_map(x => x%2 === 1?0:1, integrate_series(sine_series)))

    expectIteration(exp_series, Array(MAX).fill(1))
    expectIteration(cosine_series, Array(MAX).fill(null).map((x, i) => i % 2 === 0?1:0))
    expectIteration(sine_series, Array(MAX).fill(null).map((x, i) => i % 2 === 0?0:1))

    // exec3.60
    // function mul_series(s1, s2) {
    //   return pair(
    //     car(s1) * car(s2),
    //     () => add_streams(
    //       add_streams(
    //         stream_scale(stream_cdr(s1), car(s2)),
    //         stream_scale(stream_cdr(s2), car(s1))
    //       ),
    //       mul_series(stream_cdr(s1), stream_cdr(s2))
    //     )
    //   )
    // }
    //
    // const sin2xAddcos2xStream = partial_sums(
    //   add_streams(
    //     mul_series(cosine_series, cosine_series),
    //     mul_series(sine_series, sine_series)
    //   )
    // )
    //
    // expectIteration(sin2xAddcos2xStream, Array(MAX).fill(1))
  })
})
