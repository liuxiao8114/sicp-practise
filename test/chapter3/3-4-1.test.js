describe('chapter 3-4-1', () => {
  const { Account } = require('../../src/chapter3/3-4-1.js')

  it('init an account and do sth' ,() => {
    const a = new Account(100)
    a.withdraw(25)
    a.deposit(125)
    
    expect(a.balance).toBe(200)
  })

  it('test dispatch' ,() => {
    const a = new Account(100)
    a.dispatch('withdraw')(25)
    a.dispatch('deposit')(125)

    expect(a.balance).toBe(200)
    expect(() => a.dispatch('Unknown')(25)).toThrow()
  })
})
