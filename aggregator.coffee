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
    oldValue = @cachedValue
    @events.emit('change', @cachedValue, oldValue) unless @compute() is oldValue
  compute: ->
    @cachedValue = @implementation.compute.call(this)
  value: ->
    @cachedValue

exports.buildAggregator = (implementation)-> ((opts) -> new Aggregator(implementation, opts))