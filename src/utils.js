module.exports = {
  Cons,
  isPair,
  List,
  Queue,
  car,
  cdr,
  pair,
  list,
  isNull,
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
  getCaadr() {
    if(!isPair(this.cdr) || !isPair(this.cdr.car))
      throw new Error(`no caadr in pair: ${this.toString()}`)
    return this.cdr.car.car
  },
  getCaddr() {
    if(!isPair(this.cdr) || !isPair(this.cdr.cdr))
      throw new Error(`no caddr in pair: ${this.toString()}`)
    return this.cdr.cdr.car
  },
  getCdadr() {
    if(!isPair(this.cdr) || !isPair(this.cdr.car))
      throw new Error(`no caddr in pair: ${this.toString()}`)
    return this.cdr.car.cdr
  },
  getCdddr() {
    if(!isPair(this.cdr) || !isPair(this.cdr.cdr))
      throw new Error(`no cdddr in pair: ${this.toString()}`)
    return this.cdr.cdr.cdr
  },
  toString() {
    if(!this.car && !this.cdr)
      return "'()"
    return `(cons ${this.car} ${this.cdr})`
  },
}

Cons.prototype.valueOf = Cons.prototype.toString

/*
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

(1 2 3)
(cons 1 (cons 2 (cons 3 null)))

(1 (2 3))
(cons 1 (cons (cons 2 (cons 3 null)) null))

((1 2) 3)
(cons (cons 1 (cons 2 null)) (cons 3 null))
*/
function List(...values) {
  if(values.length === 0)
    return null
  else if(values.length === 1) {
    return Cons.call(this, values[0], null)
    // this.car = values[0]
    // this.cdr = null
  } else {
    // return
    this.car = values[0]
    this.cdr = new List(...values.slice(1))
  }
}

List.prototype = Object.create(Cons.prototype, {
  constructor: List,
})

function listToString(s, l) {
  if(l == null)
    return s
  if(l.car == null && l.cdr == null)
    return `${s}'())`
  if(l.cdr == null)
    return `${s}${l.car.toString()})`
  if(l.cdr instanceof List)
    return listToString(`${s}${l.car.toString()} `, l.cdr)
  return listToString(`${s}${l.car.toString()} ${l.cdr.toString()} `)
}
List.prototype.toString = function() {
  // if(this.car == null && this.cdr == null)
  //   return "'()"
  // if(this.cdr == null)
  //   return this.car.toString() + ')'
  // if(this.cdr instanceof List)
  //   return this.car.toString() + ' ' + this.cdr.toString()
  // return '(' + this.car.toString() + ' ' + this.cdr.toString()
  return listToString('(', this)
}

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

function car(p) {
  if(!isPair(p))
    throw new Error(`car() needs a Cons instance param but got: ${p}, ${typeof p} instead.`)
  return p.car
}

function cdr(p) {
  if(!isPair(p))
    throw new Error(`cdr() needs a Cons instance param but got: ${p}, ${typeof p} instead.`)
  return p.cdr
}

function isNull(p) {
  return p == null || (isPair(p) && car(p) == null)
}

function pair(a, b) {
  return new Cons(a, b)
}

function list(...values) {
  return new List(...values)
}
