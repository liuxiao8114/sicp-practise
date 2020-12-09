function JSNumber() {
  this.type = jsNumberExp
}

function jsNumberExp(x, y) {
  return {
    add: x + y,
    sub: x - y,
    mul: x * y,
    div: x / y
  }
}

function Rational(x, y) {
  this.type = rationalExp
  this.numer = x
  this.demon = y
}

function rationalExp(x, y) {
  return {
    add: new Rational(x.numer + y.numer, x.demon + y.demon),
    sub: new Rational(x.numer - y.numer, x.demon - y.demon),
    mul: new Rational(x.numer * y.numer, x.demon * y.demon),
    div: new Rational(x.numer * y.demon, x.demon * y.numer)
  }
}

function findExpression(a, b) {
  let typeA = a.type, typeB = b.type
  let expressions = [ jsNumberExp, rationalExp ]

  function coercion(a, b) {

  }

  if(!typeA || !typeB) {
    return jsNumberExp
  }
  if(typeA !== typeB) return coercion(typeA, typeB)

  let expression =  expressions.find(typeA)
  if(!expression) throw new Error('no expression with this type: ' + typeA)
  return expression(a, b)
}

let dispatch = type => (a, b) => findExpression(a, b)[type]

let caculator = () => {
  let exp = [ 'add', 'sub', 'mul', 'div' ]
  let ret = {}
  exp.forEach(item => {
    ret[item] = dispatch(item)
  })
  return ret
}

let x = 1, y = 2
let m = new Rational(3, 4), n = new Rational(1, 2)

caculator.add(x, y)
caculator.add(m, n)
