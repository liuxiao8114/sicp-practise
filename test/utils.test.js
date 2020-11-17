const utils = require('../src/utils')

describe('util test cases', () => {
  describe('list test cases', () => {
    it('list', () => {
      const { List } = utils
      const l = new List(1, 2, 3, 4)
      // expect(l.toString()).toEqual(`(1, (2, (3, (4, null))))`)
      // expect(l.reverse().toString()).toEqual(`(4, (3, (2, (1, null))))`)
    })
  })

  describe('queue test cases', () => {
    const { Queue } = utils

    it('pop queue', () => {
      const popQueue = new Queue(1, 2, 3, 4, 5)
      expect(popQueue.pop()).toBe(5)
      expect(popQueue.pop()).toBe(4)
      expect(popQueue.pop()).toBe(3)
      expect(popQueue.pop()).toBe(2)
      expect(popQueue.pop()).toBe(1)
      expect(() => { popQueue.pop() }).toThrow()
    })

    it('shift queue', () => {
      const shiftQueue = new Queue(1, 2, 3, 4, 5)
      expect(shiftQueue.shift()).toBe(1)
      expect(shiftQueue.shift()).toBe(2)
      expect(shiftQueue.shift()).toBe(3)
      expect(shiftQueue.shift()).toBe(4)
      expect(shiftQueue.shift()).toBe(5)
      expect(() => { shiftQueue.shift() }).toThrow()
    })
  })
})
