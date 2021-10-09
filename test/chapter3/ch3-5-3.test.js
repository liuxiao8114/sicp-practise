const path = require('path')

const SRC_ROOT = `../../src/chapter3/`
const { Cons, isNull, car, pair, list, square } = require(path.join(SRC_ROOT, 'utils'))
const {
  memo,
  stream_cdr, stream_ref,
  stream_map, stream_filter
} = require(path.join(SRC_ROOT, 'ch3-5-1'))

const {
  stream_scale, stream_map2_memo,
  integers, integersMemo
} = require(path.join(SRC_ROOT, 'ch3-5-2'))

const {
  sqrt_stream, pi_summands, euler_transform, accelerated_sequence,
  pairs, interleave, integral,
} = require(path.join(SRC_ROOT, 'ch3-5-3'))

const TO_FIXED = 5

function expectIteration(stream, expectList) {
  let next = stream

  expectList.forEach(item => {
    if(typeof item === 'object')
      expect(car(next).toString()).toBe(item.toString())
    else
      expect(car(next)).toBe(item)
    next = stream_cdr(next)
  })
}

function consoleLogIteration(...args) {
  let result = ``,
      counter = TO_FIXED,
      streams
  if(typeof args[args.length - 1] === 'number') {
    counter = args[args.length - 1]
    streams = args.slice(0, -1)
  } else {
    streams = args
  }

  const nexts = streams.slice()

  for(let i = 0; i < counter; i++) {
    result += `${i}: `

    for(let j = 0; j < streams.length; j++) {
      result += `${car(nexts[j])}, `
      nexts[j] = stream_cdr(nexts[j])
    }

    result += `\r\n`
  }

  console.log(result)
}

describe('chapter 3-5-3', () => {
  it('sqrt_stream', () => {
    consoleLogIteration(sqrt_stream(2))
  })

  it('compares pi_summands, euler_transform and accelerated_sequence', () => {
    function add_streams_memo(s1, s2) {
      return stream_map2_memo((x, y) => x + y, s1, s2)
    }

    function partial_sums2(stream) {
      return add_streams_memo(stream, pair(0, () => partial_sums2(stream)))
    }

    const pi_stream = stream_scale(partial_sums2(pi_summands(1)), 4)
    consoleLogIteration(
      pi_stream,
      euler_transform(pi_stream),
      accelerated_sequence(euler_transform, pi_stream)
    )
  })
})

describe('chapter 3-5-3 exercises', () => {
  it('exec3.64', () => {
    function stream_limit(s, n) {
      function iter(lastCar, currentStream, n) {
        const currentCar = car(currentStream)
        if(Math.abs(lastCar - currentCar) < n)
          return currentCar

        return iter(currentCar, stream_cdr(currentStream), n)
      }

      return iter(car(s), stream_cdr(s), n)
    }

    function sqrt(x, tolerance) {
      return stream_limit(sqrt_stream(x), tolerance)
    }

    expect(sqrt(3, Math.pow(10, -TO_FIXED)).toFixed(TO_FIXED)).toBe('1.73205')
  })

  it('exec3.65', () => {
    /* ln2 = 1 - 1/2 + 1/3 - 1/4 ... */
    function ln_summands(n) {
      return pair(1/n, () => stream_map(x => -x, ln_summands(n + 1)))
    }

    function add_streams_memo(s1, s2) {
      return stream_map2_memo((x, y) => x + y, s1, s2)
    }

    function partial_sums2(stream) {
      return add_streams_memo(stream, pair(0, () => partial_sums2(stream)))
    }

    partial_sums2(ln_summands(1))
  })

  it('exec3.66', () => {
    const integersPairs = pairs(integers, integers)
    // how many pairs precede the pair (1,100)? ->
    // the pair (99,100)? ->
    // the pair (100,100)? ->
    expect(stream_ref(integersPairs, 197).toString()).toBe(list(1, 100).toString())
  })

  it('exec3.67', () => {
    function stream_map_memo(fn, s) {
      return pair(fn(car(s)), memo(() => stream_map_memo(fn, stream_cdr(s))))
    }

    function downPairs(s, t) {
      return pair(
        list(car(s), car(t)),
        memo(
          () => interleave(
            stream_map_memo(x => list(x, car(t)), stream_cdr(s)),
            downPairs(stream_cdr(s), stream_cdr(t))
          )
        )
      )
    }

    expectIteration(
      interleave(
        pairs(integers, integers),
        downPairs(stream_cdr(integers), integers)
      ),
      [ list(1,1), list(2,1), list(1,2), list(3,1), list(2,2), list(3,2), list(1,3), list(4,1) ]
    )

    function full(s, t) {
      return pair(
        list(car(s), car(t)),
        memo(
          () => interleave(
            interleave(
              stream_map_memo(x => list(x, car(t)), stream_cdr(s)),
              stream_map_memo(x => list(car(s), x), stream_cdr(t)),
            ),
            full(stream_cdr(s), stream_cdr(t))
          )
        )
      )
    }

    expectIteration(
      full(integers, integers),
      [ list(1,1), list(2,1), list(2,2), list(1,2), list(3,2), list(3,1), list(3,3), list(1,3), list(2,3), list(4,1) ]
    )
  })

  it('exec3.68. Call pairsX will result in an endless recursive calling on pairsX.', () => {
    function pairsX(s, t) {
      return interleave(
        stream_map(x => list(car(s), x), t),
        pairsX(stream_cdr(s), stream_cdr(t))
      )
    }
  })

  it('exec3.69', () => {
    function triples(s, t, u) {
      return pair(
        list(car(s), car(t), car(u)),
        () => interleave(
          interleave(
            stream_map(x => list(car(s), car(t), x), stream_cdr(u)),
            stream_map(x => pair(car(s), x), pairs(stream_cdr(t), stream_cdr(u))),
          ),
          triples(stream_cdr(s), stream_cdr(t), stream_cdr(u))
        )
      )
    }

    const pythagorean = stream_filter(
      x => (square(x.car) + square(x.cdr.car) === square(x.cdr.cdr.car)),
      triples(
        stream_cdr(stream_cdr(integersMemo)),
        stream_cdr(stream_cdr(integersMemo)),
        stream_cdr(stream_cdr(integersMemo))
      )
    )

    consoleLogIteration(pythagorean, 3) // buffer overflow...
    /* (1,1,1), (1,1,2), (2,2,2), (1,2,2), (2,2,3), (1,1,3), (3,3,3), (1,2,3) */
    // consoleLogIteration(triples(integersMemo, integersMemo, integersMemo), 100)
    //
    // function stream_equal(s, x, index = 0) {
    //   let compare
    //   if(x instanceof Cons)
    //     compare = (car(s).toString() === x.toString())
    //   else
    //     compare = car(s) === x
    //   return compare ? index : stream_equal(stream_cdr(s), x, index + 1)
    // }
    //
    // console.log(stream_equal(triples(integersMemo, integersMemo, integersMemo), list(5, 12, 13)))
  })

  it('exec3.70', () => {
    function merge_weight(s1, s2, wfn) {
      if(isNull(s1))
        return s2
      return isNull(s1) ? s2 :
        wfn(car(s1)) < wfn(car(s2)) ?
          pair(car(s1), () => merge_weight(stream_cdr(s1), s2, wfn)) :
          pair(car(s2), () => merge_weight(s1, stream_cdr(s2), wfn))
    }

    function weighted_pairs(s, t, wfn) {
      return pair(
        list(car(s), car(t)),
        () => merge_weight(
          stream_map(x => list(car(s), x), stream_cdr(t)),
          weighted_pairs(stream_cdr(s), stream_cdr(t), wfn),
          wfn
        )
      )
    }

    function listWeightFnA(s) {
      if(!(s instanceof Cons))
        throw new Error('listWeightFn need a List param.')
      return s.car + s.cdr.car
    }

    // a.
    expectIteration(
      weighted_pairs(integers, integers, listWeightFnA),
      [ list(1, 1), list(1, 2), list(2, 2), list(1, 3), list(2, 3), list(1, 4), list(3, 3) ]
    )

    function listWeightFnB(s) {
      if(!(s instanceof Cons))
        throw new Error('listWeightFn need a List param.')
      return s.car * 2 + s.cdr.car * 3 + s.car * s.cdr.car * 5
    }

    function isNotDividedBy235(x) {
      if(typeof x !== 'number')
        throw new Error('isNotDividedBy235')
      return x % 2 !== 0 && x % 3 !== 0 && x % 5 !== 0
    }

    function weighted_pairsB(s, t, wfn) {
      return stream_filter(
        x => isNotDividedBy235(x.car) && isNotDividedBy235(x.cdr.car),
        weighted_pairs(s, t, wfn)
      )
    }

    // b.
    expectIteration(
      weighted_pairsB(integers, integers, listWeightFnB),
      [ list(1, 1), list(1, 7), list(1, 11), list(1, 13), list(1, 17), list(1, 19), list(1, 23) ]
    )

    function cube(x) { return x * x * x }

    function listWeightFn71(s) {
      if(!(s instanceof Cons))
        throw new Error('listWeightFn need a List param.')
      return s.car * 3 + s.cdr.car * 3 + s.car * s.cdr.car * 5
    }
  })

  it('exec3.73', () => {
    function rc(r, c, dt) {
      return (i, v0) => stream_map(x => (1/c) * x + r * x, integral(i, v0, dt))
    }
  })

  it('exec3.74 ~ 3.76', () => {
    function sign_change_detector(next, current) {
      if(current >= 0 && next < 0)
        return -1
      if(current < 0 && next >= 0)
        return 1
      return 0
    }

    const fiveCrossing = stream_map(x => x % 5 === 0 ? -x : x, integers)
    const EXPECTED = [ 0,0,0,0,-1,1,0 ]

    function make_zero_crossings_boss(input, initValue = 0) {
      const output = pair(
        sign_change_detector(car(input), initValue),
        () => stream_map2_memo(sign_change_detector, stream_cdr(input), output)
      )

      return output
    }

    function make_zero_crossings_alyssa(input, lastValue = 0) {
      return pair(
        sign_change_detector(car(input), lastValue),
        () => make_zero_crossings_alyssa(stream_cdr(input), car(input))
      )
    }

    expectIteration(make_zero_crossings_boss(fiveCrossing), EXPECTED)
    expectIteration(make_zero_crossings_alyssa(fiveCrossing), EXPECTED)

    // function make_zero_crossings_louis(input_stream, last_value) {
    //   const avpt = (car(input_stream) + last_value) / 2
    //   console.log(`avpt: ${car(input_stream)}, ${last_value}, ${avpt}`)
    //   return pair(
    //     sign_change_detector(avpt, last_value),
    //     () => make_zero_crossings_louis(stream_cdr(input_stream), avpt)
    //   )
    // }
    function make_zero_crossings_louis(input_stream, last_value, last_avpt) {
      const avpt = (car(input_stream) + last_value) / 2
      // console.log(`avpt: ${car(input_stream)}, ${last_value}, ${avpt}`)
      return pair(
        sign_change_detector(avpt, last_avpt),
        () => make_zero_crossings_louis(stream_cdr(input_stream), car(input_stream), avpt)
      )
    }

    expectIteration(make_zero_crossings_louis(fiveCrossing, 0, 0), EXPECTED)

    // exec3.76
    function smooth(input) {
      const output = pair(
        car(input),
        () => stream_map2_memo((x, y) => (x + y) / 2, stream_cdr(input), input)
      )

      return output
    }

    function make_zero_crossings_Eva(input_stream) {
      return make_zero_crossings_alyssa(smooth(input_stream))
    }
    expectIteration(make_zero_crossings_Eva(fiveCrossing), EXPECTED)
  })
})
