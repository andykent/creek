class TimeboxedMin
  constructor: (opts) ->
    @period = (opts.period or 60) * 1000
    @precision = (opts.precision or 1) * 1000
    @blocks = []
  push: (time, value) ->
    @maybeCreateNewBlock(time)
    oldValue = @blocks[@blocks.length-1].data
    @blocks[@blocks.length-1].data = value if oldValue == null or oldValue > value
    @cleanup()
  compute: ->
    @cleanup()
    min = null
    for block in @blocks
      min = block.data if min == null or min > block.data
    min
  maybeCreateNewBlock: (time) ->
    if @blocks.length == 0
      @blocks.push( time:time, data:null )
      return
    lastBlockTime = @blocks[@blocks.length-1].time
    diff = time - lastBlockTime.getTime()
    @blocks.push( time:time, data:null ) if diff > @precision
  cleanup: ->
    periodThreshold = new Date().getTime() - @period
    loop
      break if @blocks.length == 0 or @blocks[0].time.getTime() > periodThreshold
      @blocks.shift()
    

exports.TimeboxedMin = TimeboxedMin