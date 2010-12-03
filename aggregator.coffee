events = require('events')

class Aggregator
  constructor: (name, implementation, opts) ->
    @name = name
    @implementation = implementation
    @opts = opts
    @implementation.init.call(this, @opts)
    @cachedValue = null
    @events = new events.EventEmitter()
  on: (event, callback) ->
    @events.on(event, callback)
  push: (time, values) ->
    values = [values] unless Array.isArray(values)
    for value in values
      value = @opts.before.call(this, value) if @opts.before
      @implementation.push.call(this, time, value) unless value is undefined
    oldValue = @cachedValue
    @events.emit('change', @cachedValue, oldValue) unless @compute() is oldValue
  compute: ->
    @cachedValue = @implementation.compute.call(this)
    @cachedValue = @opts.after.call(this, @cachedValue) if @opts.after
    @cachedValue
  value: ->
    @cachedValue

exports.buildAggregator = (name, implementation)-> ((opts) -> new Aggregator(name, implementation, opts))