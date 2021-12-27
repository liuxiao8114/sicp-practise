const utils = require('../src/utils')

describe('util test cases', () => {
  describe('list test cases', () => {
    const { Cons, List } = utils

    it('constructs list using number', () => {
      const l = new List(1, 2, 3, 4)

      expect(Object.getPrototypeOf(List.prototype)).toBe(Cons.prototype)
      expect(Object.getPrototypeOf(l)).toBe(List.prototype)
      expect(l.getCar()).toBe(1)
      expect(l.getCadr()).toBe(2)
      // expect(l.toString()).toEqual(`(1, (2, (3, (4, null))))`)
      // expect(l.reverse().toString()).toEqual(`(4, (3, (2, (1, null))))`)
      expect(l.toString()).toEqual(`(1 2 3 4)`)
      // expect(l.reverse().toString()).toEqual(`(list 4 3 2 1)`)
    })

    it('mixes list with cons', () => {
      const sub1 = new List(2, 3)
      const test1 = new Cons(1, sub1)
      // expect(test1.toString()).toEqual(`(1, (2, (3, null)))`)
      expect(test1.toString()).toEqual(`(cons 1 (2 3))`)
    })

    it('constructs recursive list', () => {
      const l1 = new List(1, new List(2, 3))
      const L1 = `(1 (2 3))`
      expect(l1.toString()).toBe(L1)

      const l2 = new List(new List(1, 2), 3)
      const L2 = `((1 2) 3)`
      expect(l2.toString()).toBe(L2)

      const l3 = new List(l1, l2)
      expect(l3.toString()).toBe(`(${L1} ${L2})`)
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
