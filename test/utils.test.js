describe('util test cases', () => {
  describe('list test cases', () => {
    it('list', () => {
      const { list } = require('../src/utils')
      console.log(list(1, 2, 3, 4).toString())
    })
  })
})
