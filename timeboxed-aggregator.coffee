events = require('events')

class TimeboxedAggregator
  constructor: (implementation, opts) ->
    @implementation = implementation
    @period = (opts.period or 60) * 1000
    @precision = (opts.precision or 1) * 1000
    @cachedValue = null
    @blocks = []
    @implementation.init.call(this, opts) if @implementation.init
    @events = new events.EventEmitter()
  on: (event, callback) ->
    @events.on(event, callback)
  push: (time, value) ->
    currentBlock = @maybeCreateNewBlock(time)
    currentBlock.data = @implementation.recalculateBlockData.call(this, currentBlock.data, value, currentBlock.time, time)
    oldValue = @cachedValue
    @events.emit('change', @cachedValue, oldValue) unless @compute() is oldValue
  compute: ->
    @cleanup()
    @cachedValue = @implementation.computeFromBlocks.call(this, @blocks)
  value: ->
    @cachedValue
  maybeCreateNewBlock: (time) ->
    if @blocks.length == 0
      @blocks.push( time:time, data:@defaultBlockValue() )
      return @blocks[@blocks.length-1]
    lastBlockTime = @blocks[@blocks.length-1].time
    diff = time - lastBlockTime.getTime()
    @blocks.push( time:time, data:@defaultBlockValue() ) if diff > @precision
    @blocks[@blocks.length-1]
  cleanup: ->
    periodThreshold = new Date().getTime() - @period
    loop
      break if @blocks.length == 0 or @blocks[0].time.getTime() > periodThreshold
      @blocks.shift()
  defaultBlockValue: -> 
    if @implementation.defaultBlockValue then @implementation.defaultBlockValue.call(this) else null

exports.TimeboxedAggregator = TimeboxedAggregator

exports.buildTimeboxedAggregator = (implementation)-> ((opts) -> new TimeboxedAggregator(implementation, opts))