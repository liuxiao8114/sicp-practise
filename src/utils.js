module.exports = {
  isPair,
  list: list(),
}

function isPair(p) {
  return p instanceof Cons
}

function list(pattern) {
  if(!pattern)
    pattern = recursivePairs

  function recursivePairs(values, i) {
    if(!values[i]) return null
    return new Cons(values[i], recursivePairs(values, i + 1))
  }

  function queueList() {

  }

  return (...values) => pattern(values, 0)
}

function reverseList(list) {

}

function Cons(a, b) {
  this.car = a
  this.cdr = b
}

Cons.prototype = {
  setCar(n) {
    this.car = n
  },
  setCdr(n) {
    this.cdr = n
  },
  getCar() {
    return this.car
  },
  getCdr() {
    return this.cdr
  },
  getCadr() {
    if(!isPair(this.cdr))
      throw new Error(`no cadr in pair: ${this.toString()}`)
    return this.cdr.car
  },
  toString() {
    return `(${this.car}, ${this.cdr})`
  }
}

function Node(value, next = null, prev = null) {
  this.next = next
  this.prev = prev
  this.value = value
}

function Queue(...values) {
  this.first = null
  this.rear = null

  this.init(values)
}

Queue.prototype = {
  init(...values) {
    for(let value of values) {
      this.enQueue(value)
    }
  },
  enQueue(a) {
    if(!this.first)
      this.rear = this.first = new Node(a)
    else {
      const temp = this.first
      this.first = new Node(a, temp)
    }
  },
  deQueue() {
    if(this.isEmpty())
      throw new Error('Queue is empty and cannot deQueue')
    const temp = this.rear

    if(temp === this.first)
      this.first = this.rear = null
  },
  search(s) {

  },
  isEmpty() {
    return !this.first || !this.rear
  }
}
