events = require('events')

class TimeboxedAggregator
  constructor: (name, implementation, opts) ->
    @name = name
    @opts = opts
    @implementation = implementation
    @period = (opts.period or 60) * 1000
    @precision = (opts.precision or 1) * 1000
    @cachedValue = null
    @blocks = []
    @implementation.init.call(this, opts) if @implementation.init
    @events = new events.EventEmitter()
    @staleCache =  false
  on: (event, callback) ->
    @events.on(event, callback)
  push: (time, values) ->
    currentBlock = @maybeCreateNewBlock(time)
    values = [values] unless Array.isArray(values)
    for value in values
      value = @opts.before.call(this, value) if @opts.before
      currentBlock.data = @implementation.recalculateBlockData.call(this, currentBlock.data, value, currentBlock.time, time) unless value is undefined
    oldValue = @cachedValue
    @compute()
    @events.emit('change', @cachedValue, oldValue) if @events.listeners('change').length == 0 and @cachedValue != oldValue
  compute: ->
    @cleanup()
    if @staleCache
      @cachedValue = @implementation.computeFromBlocks.call(this, @blocks)
      @cachedValue = @opts.after.call(this, @cachedValue) if @opts.after
      @staleCache = false
    @cachedValue
  value: ->
    @cachedValue
  maybeCreateNewBlock: (time) ->
    if @blocks.length == 0
      @blocks.push( time:time, data:@defaultBlockValue() )
      return @blocks[@blocks.length-1]
    lastBlock = @blocks[@blocks.length-1]
    diff = time - lastBlock.time.getTime()
    if diff > @precision
      @blocks.push( time:time, data:@defaultBlockValue() )
      @blocks[@blocks.length-2].data = @implementation.closeBlock(lastBlock) if @implementation.closeBlock
      @staleCache = true
    @blocks[@blocks.length-1]
  cleanup: ->
    periodThreshold = new Date().getTime() - @period
    loop
      break if @blocks.length == 0 or @blocks[0].time.getTime() > periodThreshold
      @blocks.shift()
  defaultBlockValue: -> 
    if @implementation.defaultBlockValue then @implementation.defaultBlockValue.call(this) else null

exports.TimeboxedAggregator = TimeboxedAggregator

exports.buildTimeboxedAggregator = (name, implementation)-> ((opts) -> new TimeboxedAggregator(name, implementation, opts))