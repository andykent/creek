class Aggregator
  constructor: (implementation, opts) ->
    @implementation = implementation
    @opts = opts
    @implementation.init.call(this, @opts)
  push: (time, value) ->
    @implementation.push.call(this, time, value)
  compute: ->
    @implementation.compute.call(this)

exports.buildAggregator = (implementation)-> ((opts) -> new Aggregator(implementation, opts))