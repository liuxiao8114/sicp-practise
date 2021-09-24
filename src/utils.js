module.exports = {
  Cons,
  isPair,
  List,
  Queue,
  display,
  square,
}

function square(x) {
  return x * x
}

function display(x, method = console.log) {
  return method(x) || x
}

function isPair(p) {
  return p instanceof Cons
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
  getCddr() {
    if(!isPair(this.cdr))
      throw new Error(`no cadr in pair: ${this.toString()}`)
    return this.cdr.cdr
  },
  getCaddr() {

  },
  getCdddr() {

  },
  toString() {
    if(!this.car && !this.cdr)
      return "'()"
    return `(${this.car}, ${this.cdr})`
  },
}

Cons.prototype.valueOf = Cons.prototype.toString

function List(...values) {
  // function recursivePairs(values, i) {
  //   // console.log(values[i])
  //
  //   if(i === values.length) return null
  //   return new Cons(values[i], recursivePairs(values, i + 1))
  // }
  //
  // return recursivePairs(values, 0)
  if(values.length === 0)
    return null
  else if(values.length === 1) {
    this.car = values[0]
    this.cdr = null
  } else {
    this.car = values[0]
    this.cdr = new List(...values.slice(1))
  }
}

List.prototype = Object.create(Cons.prototype, {
  constructor: List,
})

List.prototype.reverse = function() {
  function iter(l, result = null) {
    if(l === null) return result
    return iter(l.getCdr(), new Cons(l.getCar(), result))
  }

  return iter(this)
}

function Node(value, next = null, prev = null) {
  this.next = next
  this.prev = prev
  this.value = value
}

function Queue(...values) {
  this.first = null
  this.rear = null
  this.length = 0

  this.init(...values)
}

Queue.prototype = {
  init(...values) {
    this.first = null
    this.rear = null

    for(let value of values)
      this.push(value)
  },
  unshift(value) {
    if(!this.first) {
      const newNode = new Node(value)
      this.first = newNode
      this.rear = newNode
    } else {
      const temp = this.first
      const newNode = new Node(value, temp)
      temp.prev = newNode
      this.first = newNode
    }
    this.length++
    return this
  },
  shift() {
    if(this.isEmpty())
      throw new Error('Queue is empty and cannot execute shift()')

    const temp = this.first
    if(temp === this.rear)
      this.first = this.rear = null
    else {
      this.first = temp.next
      this.first.prev = null
    }
    this.length--
    return temp.value
  },
  push(value) {
    if(!this.first) {
      const newNode = new Node(value)
      this.first = newNode
      this.rear = newNode
    } else {
      const temp = this.rear
      const newNode = new Node(value, null, temp)
      temp.next = newNode
      this.rear = newNode
    }
    this.length++
    return this
  },
  pop() {
    if(this.isEmpty())
      throw new Error('Queue is empty and cannot execute pop()')

    const temp = this.rear
    if(temp === this.first)
      this.first = this.rear = null
    else {
      this.rear = temp.prev
      this.rear.next = null
    }
    this.length--
    return temp.value
  },
  reverse() {

  },
  search(a) {

  },
  size() {
    return this.length
  },
  isEmpty() {
    return this.length === 0
  },
}
