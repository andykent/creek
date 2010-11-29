class TimeboxedMean
  constructor: (opts) ->
    @period = (opts.period or 60) * 1000
    @precision = (opts.precision or 1) * 1000
    @blocks = []
  push: (time, value) ->
    @maybeCreateNewBlock(time)
    @currentBlockTime ?= time
    @blocks[@blocks.length-1].data.count ++
    @blocks[@blocks.length-1].data.total += value
    @cleanup()
  compute: ->
    @cleanup()
    total = 0
    count = 0
    for block in @blocks
      total += block.data.total
      count += block.data.count
    total / count
  maybeCreateNewBlock: (time) ->
    if @blocks.length == 0
      @blocks.push( time:time, data:{total:0, count:0} )
      return
    lastBlockTime = @blocks[@blocks.length-1].time
    diff = time - lastBlockTime.getTime()
    @blocks.push( time:time, data:{total:0, count:0} ) if diff > @precision
  cleanup: ->
    periodThreshold = new Date().getTime() - @period
    loop
      break if @blocks.length == 0 or @blocks[0].time.getTime() > periodThreshold
      @blocks.shift()
    

exports.TimeboxedMean = TimeboxedMean