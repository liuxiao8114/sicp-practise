describe('chapter2', () => {
  it('2-5-1.js', () => {
    const {
      Express,
      SchemeNumber,
      Rational,
      Complex,
    } = require('../../src/chapter2/2-5-1')

    expect(Express.add(new SchemeNumber(1), new SchemeNumber(2)).toString()).toBe(3)
  })
})
