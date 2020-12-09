describe('chapter 1-3-3', () => {
  const { search, fixPoint, sqrt } = require('../../src/chapter1/1-3-3')

  it('searches!', () => {
    expect(search(x => x * x - 2 * x + 1, 0, 10)).toBe(1)
    expect(search(x => x * x - 2 * x + 1, 0, 10)).toBe(1)
  })

  it('fixPoint test in 1.35', () => {
    console.log('give the answer: ' + fixPoint(x => 1 + 1 / x, 1.0))
  })

  it('tests sqrt', () => {
    expect(sqrt(4).toFixed(2)).toEqual(2.0.toFixed(2))
  })
})
