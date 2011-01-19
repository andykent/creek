aggregator = require('../aggregator')
timeboxedAggregator = require('../timeboxed-aggregator')

exports.alltime = aggregator.buildAggregator 'Alltime Maximum',
  init: (opts) -> @max = null
  push: (time, value) -> @max = value if @max == null or @max < value
  compute: -> @max

exports.timeboxed = timeboxedAggregator.buildTimeboxedAggregator 'Timeboxed Maximum',
  recalculateBlockData: (blockData, value) ->
    if blockData is null or blockData < value then value else blockData
  computeFromBlocks: (blocks) ->
    max = null
    for block in blocks
      max = block.data if max == null or max < block.data
    max