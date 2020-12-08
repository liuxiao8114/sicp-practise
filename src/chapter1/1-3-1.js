// 1.3.1 Procedures as Arguments
exports.sum = (isRecursive = false) => {
  if(isRecursive)
    return sumRecursiveProc
  return sumIterProc
}

function sumRecursiveProc(term, next, from, to) {
  if(from > to)
    return 0

  return term(from) + sumRecursiveProc(term, next, next(from), to)
}

// 1-30
function sumIterProc(term, next, from, to) {
  function iter(current, result) {
    if(current > to)
      return result
    return iter(next(current), result + term(current))
  }

  return iter(from, 0)
}
