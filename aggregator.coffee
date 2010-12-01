events = require('events')

class Aggregator
  constructor: (implementation, opts) ->
    @implementation = implementation
    @opts = opts
    @implementation.init.call(this, @opts)
    @cachedValue = null
    @events = new events.EventEmitter()
  on: (event, callback) ->
    @events.on(event, callback)
  push: (time, value) ->
    @implementation.push.call(this, time, value)
  compute: ->
    oldValue = @cachedValue
    @cachedValue = @implementation.compute.call(this)
    @events.emit('change', @cachedValue, oldValue)
    @cachedValue

exports.buildAggregator = (implementation)-> ((opts) -> new Aggregator(implementation, opts))