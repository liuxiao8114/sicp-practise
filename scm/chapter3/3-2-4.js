function sqrt(x) {
  const LIMIT = 0.000001

  function isGoodEnough(guess) {
    return Math.abs(square(guess)) - x < LIMIT
  }

  function improve(guess) {
    return average(guess, (x / guess))
  }

  function sqrtIter(guess) {
    if(isGoodEnough(guess)) return guess
    return sqrtIter(improve(guess))
  }
  
  sqrtIter(1.0)
}

function square(x) {
  return x * x
}

function average(x, y) {
  return (x + y) / 2
}
