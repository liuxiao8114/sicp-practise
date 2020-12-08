describe('chapter 1-3-1', () => {
  const { sum } = require('../../src/chapter1/1-3-1')

  function interity(x) { return x }
  function inc(x) { return x + 1 }
  function cube(x) { return x * x * x }
  function piTerm(x) { return 1.0 / ((x + 2) * x) }
  function piNext(x) { return x + 4 }

  const OneToTen = 55
  const OneToFiveCube = 225 // 1 + 8 + 27 + 64 + 125 = 225

  describe('doSum cases', () => {
    const doSum = sum(true) //recursive process

    it('sums interity', () => {
      expect(doSum(interity, inc, 1, 10)).toBe(OneToTen)
    })

    it('sums cube', () => {
      expect(doSum(cube, inc, 1, 5)).toBe(OneToFiveCube)
    })

    it('sums to simulate pi', () => {
      console.log(
        'simulate pi by recursive: ' +
        doSum(piTerm, piNext, 1, 1000) * 8
      )
    })
  })

  describe('doSum cases', () => {
    const doSum = sum()

    it('sums interity', () => {
      expect(doSum(interity, inc, 1, 10)).toBe(OneToTen)
    })

    it('sums cube', () => {
      expect(doSum(cube, inc, 1, 5)).toBe(OneToFiveCube)
    })

    it('sums to simulate pi', () => {
      console.log(
        'simulate pi by iterative: ' +
        doSum(piTerm, piNext, 1, 1000) * 8
      )
    })
  })
})
