describe('chapter 1-2-4', () => {
  const { fastExpt, expt } = require('../../src/chapter1/1-2-4')

  it('tests fast expt using fastExptRecursiveProc', () => {
    expect(fastExpt(10, 3, false)).toBe(1000)
    expect(fastExpt(10, 4, false)).toBe(10000)
  })

  it('tests fast expt using fastExptIterProc', () => {
    expect(fastExpt(10, 3, true)).toBe(1000)
    expect(fastExpt(10, 4, true)).toBe(10000)
  })
})
