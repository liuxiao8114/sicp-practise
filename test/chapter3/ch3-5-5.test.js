const path = require('path')

const SRC_ROOT = `../../src/chapter3/`
const { isNull, car, pair } = require(path.join(SRC_ROOT, 'utils'))

const {
  memo,
  stream_cdr, stream_ref,
  stream_map
} = require(path.join(SRC_ROOT, 'ch3-5-1'))

const { gcd, pi } = require(path.join(SRC_ROOT, 'ch3-5-5'))

describe('chapter 3-5-5', () => {
  it('gcd', () => {
    expect(gcd(2, 3)).toBe(1)
    expect(gcd(2, 4)).toBe(2)
    expect(gcd(2, 5)).toBe(1)
  })

  it('approximate pi', () => {
    expect(stream_ref(pi, 10000).toFixed(2)).toBe('3.14')
  })
})
