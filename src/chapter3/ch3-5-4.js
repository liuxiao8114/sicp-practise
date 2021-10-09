const { pair } = require('./utils')
const { stream_map, memo } = require('./ch3-5-1')
const { add_streams_memo, stream_scale } = require('./ch3-5-2')

function integral(delayed_integrand, initial_value, dt) {
  const integ = pair(
    initial_value,
    memo(
      () => add_streams_memo(stream_scale(delayed_integrand(), dt), integ)
    )
  )

  return integ
}

function solve(f, y0, dt) {
  const y = integral(() => dy, y0, dt)
  const dy = stream_map(f, y)

  return y
}

module.exports = {
  integral,
  solve,
}
