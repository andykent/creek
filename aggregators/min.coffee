aggregator = require('../aggregator')
timeboxedAggregator = require('../timeboxed-aggregator')

exports.alltime = aggregator.buildAggregator 'Alltime Minimum'
  init: (opts) -> @max = null
  push: (time, value) -> @max = value if @max == null or @max > value
  compute: -> @max

exports.timeboxed = timeboxedAggregator.buildTimeboxedAggregator 'Timeboxed Minimum'
  recalculateBlockData: (blockData, value) ->
    if blockData is null or blockData > value then value else blockData
  computeFromBlocks: (blocks) ->
    min = null
    for block in blocks
      min = block.data if min == null or min > block.data
    min