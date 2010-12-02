aggregator = require('../aggregator')
timeboxedAggregator = require('../timeboxed-aggregator')

exports.alltime = aggregator.buildAggregator 'Alltime Mean'
  init: (opts) -> 
    @count = 0
    @total = 0
  push: (time, value) ->
    @count++
    @total += value
  compute: -> @total / @count

exports.timeboxed = timeboxedAggregator.buildTimeboxedAggregator 'Timeboxed Mean'
  recalculateBlockData: (blockData, value) ->
    blockData.count ++
    blockData.total += value
    blockData
  defaultBlockValue: ->
    {total:0, count:0}
  computeFromBlocks: (blocks) ->
    total = 0
    count = 0
    for block in blocks
      total += block.data.total
      count += block.data.count
    return 0 if count is 0
    total / count