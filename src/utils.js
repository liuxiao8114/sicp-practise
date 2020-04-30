export function isPair(p) {
  return p instanceof Cons
}

export function list(...values) {
  function iter(values, i) {
    if(!values[i]) return null
    return new Cons(values[i], iter(values, i + 1))
  }

  return iter(values, 0)
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

function Node(value, next, prev) {
  this.next = next
  this.prev = prev
  this.value = value
}

function Queue() {
  this.first = null
  this.rear = null
}

Queue.prototype.enqueue = function(n) {
  if(!(n instanceof Node)) {
    n = new Node(n)
  }
  if(this.first === null) {
    this.first = n
    this.rear = n
  } else {
    let temp = this.rear
    temp.next = n
    this.rear = n
  }
}

Queue.prototype.search = function() {

}

Queue.prototype.dequeue = function() {

}
