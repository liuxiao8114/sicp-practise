const SCHEME_NUMBER = 'SCHEME_NUMBER'
const RATIONAL = 'RATIONAL'
const COMPLEX_RECT = 'COMPLEX_RECT'
const COMPLEX_POLAR = 'COMPLEX_POLAR'

function Express() {}

// this may have the same function with apply-logic in 2-5-2.scm
Express.caculator = operator => (x, y) => {
  let exp = null

  if(x.constructor && x.constructor === y.constructor) {
    exp = x.constructor
    return exp[operator](x, y)
  }

  exp = [x.constructor, y.constructor]
  exp.map(n => op[n])
}

Express.add = Express.caculator('add')
Express.sub = Express.caculator('sub')
Express.mul = Express.caculator('mul')
Express.div = Express.caculator('div')

Express.TYPE_TABLE = key => {
  return {
    [key]: {
      SchemeNumber: SchemeExpress.key,
      Rational: RationalExpress.key,
      Complex: ComplexExpress.key
    }
  }
}
  /*
  add: {
    SchemeNumber: SchemeExpress.add,
    Rational: RationalExpress.add,
    Complex: ComplexExpress.add
  },

  sub: {
    SchemeNumber: SchemeExpress.sub,
    Rational: RationalExpress.sub,
    Complex: ComplexExpress.sub
  },

  mul: {
    SchemeNumber: SchemeExpress.mul,
    Rational: RationalExpress.mul,
    Complex: ComplexExpress.mul
  },

  div: {
    SchemeNumber: SchemeExpress.div,
    Rational: RationalExpress.div,
    Complex: ComplexExpress.div
  },

  */


function SchemeNumber(x) {
  this.type = SCHEME_NUMBER
  this.num = x
}

SchemeNumber.prototype.convertToParent = () => {
  return new Rational(this.num, 1)
}

SchemeNumber.add = (x, y) => new SchemeNumber(x.num + y.num)
SchemeNumber.sub = (x, y) => new SchemeNumber(x.num - y.num)
SchemeNumber.mul = (x, y) => new SchemeNumber(x.num * y.num)
SchemeNumber.div = (x, y) => new SchemeNumber(x.num / y.num)

function Rational(num, denom) {
  this.type = RATIONAL
  this.num = num
  this.denom = denom
}

Rational.add = (x, y) => new Rational(x.num * y.denom + y.num * x.denom , x.denom * y.denom)
Rational.sub = (x, y) => new Rational(x.num * y.denom - y.num * x.denom , x.denom * y.denom)
Rational.mul = (x, y) => new Rational(x.num * y.num, x.denom * y.denom)
Rational.div = (x, y) => new Rational(x.num * y.denom, x.denom * y.num)

Rational.prototype.convertToParent = () => {
  return new Complex(this.num, 1)
}

function Complex(type, x, y) {
  const c = new [type](x, y)

  this.real = c.real
  this.imag = c.imag
  this.magnitude = c.magnitude
  this.angle = c.angle
}

Complex.TYPE_TABLE = {
  subType: {
    real: ComplexRect,
    polar: ComplexPolar
  }
}

function ComplexRect(x, y) {
  this.type = COMPLEX_RECT
  this.real = x
  this.imag = y
  this.magnitude = Math.sqrt(x * x + y * y)
  this.angle = Math.atan(x / y)
}

function ComplexPolar(x, y) {
  this.type = COMPLEX_POLAR
  this.real = x * Math.cos(y)
  this.imag = x * Math.sin(y)
  this.magnitude = x
  this.angle = y
}

Complex.add = (x, y) => new Complex(ComplexRect, x.real + y.real, x.imag + y.imag)
Complex.sub = (x, y) => new Complex(ComplexRect, x.real - y.real, x.imag - y.imag)
Complex.mul = (x, y) => new Complex(ComplexPolar, x.magnitude + y.magnitude, x.angle + y.angle)
Complex.div = (x, y) => new Complex(ComplexPolar, x.magnitude - y.magnitude, x.angle - y.angle)

//test case:
Express.add(new SchemeNumber(1), new SchemeNumber(2))
Express.mul(new SchemeNumber(3), new SchemeNumber(4))
Express.add(new Rational(1, 2), new Rational(1, 3))
Express.mul(new Rational(3, 4), new Rational(5, 6))
Express.add(new Complex(ComplexRect, 1, 2), new Complex(ComplexRect, 1, 3))
Express.mul(new Complex(ComplexRect, 3, 4), new Complex(ComplexRect, 6, 8))
