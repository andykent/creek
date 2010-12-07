aggregator = require('../aggregator')
timeboxedAggregator = require('../timeboxed-aggregator')


exports.alltime = aggregator.buildAggregator 'Alltime Sum'
  init: (opts) -> @total = 0
  push: (time, value) -> @total += value
  compute: -> @total


exports.timeboxed = timeboxedAggregator.buildTimeboxedAggregator 'Timeboxed Sum'
  recalculateBlockData: (blockData, value) ->
    blockData += value
  computeFromBlocks: (blocks) ->
    total = 0
    total += block.data for block in blocks
    total