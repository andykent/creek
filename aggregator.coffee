events = require('events')

class Aggregator
  constructor: (name, implementation, opts) ->
    @implementation = implementation
    @opts = opts
    @implementation.init.call(this, @opts)
    @cachedValue = null
    @events = new events.EventEmitter()
  on: (event, callback) ->
    @events.on(event, callback)
  push: (time, values) ->
    values = [values] unless Array.isArray(values)
    @implementation.push.call(this, time, value) for value in values
    oldValue = @cachedValue
    @events.emit('change', @cachedValue, oldValue) unless @compute() is oldValue
  compute: ->
    @cachedValue = @implementation.compute.call(this)
  value: ->
    @cachedValue

exports.buildAggregator = (name, implementation)-> ((opts) -> new Aggregator(name, implementation, opts))