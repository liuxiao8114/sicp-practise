function isEven(n) {
  return n % 2 === 0
}

function square(n) {
  return n * n
}

function expt(b, n) {

}

function fastExpt(b, n, isIterable = false) {
  if(isIterable)
    return fastExptIterProc(b, n)
  return fastExptRecursiveProc(b, n)
}

// 1.16
function fastExptIterProc(b, n) {
  function iter(b, n, ret) {
    if(n === 1) return ret
    if(isEven(n)) return iter(b, n / 2, square(b) * ret)
    return iter(b, n - 1, b * ret)
  }

  return iter(b, n, 1)
}

function fastExptRecursiveProc(b, n) {
  if(n === 1) return b
  if(isEven(n)) return square(fastExptRecursiveProc(b, n / 2))
  return fastExptRecursiveProc(b, n - 1) * b
}

function counterWrapper() {

}

// 1.17
function multi(a, b) {
  
}

exports.expt = expt
exports.fastExpt = fastExpt
