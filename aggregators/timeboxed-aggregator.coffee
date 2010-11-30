class TimeboxedAggregator
  constructor: (opts) ->
    @period = (opts.period or 60) * 1000
    @precision = (opts.precision or 1) * 1000
    @blocks = []
  push: (time, value) ->
    currentBlock = @maybeCreateNewBlock(time)
    currentBlock.data = @recalculateBlockData(currentBlock.data, value, currentBlock.time, time)
    @cleanup()
  compute: ->
    @cleanup()
    @computeFromBlocks(@blocks)
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
  defaultBlockValue: -> null

exports.TimeboxedAggregator = TimeboxedAggregator