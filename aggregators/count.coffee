aggregator = require('../aggregator')
timeboxedAggregator = require('../timeboxed-aggregator')


exports.alltime = aggregator.buildAggregator(
  init: (opts) -> @count = 0
  push: (time, value) -> @count ++
  compute: -> @count
)


exports.timeboxed = timeboxedAggregator.buildTimeboxedAggregator(
  recalculateBlockData: (blockData, value) ->
    blockData + 1
  computeFromBlocks: (blocks) ->
    count = 0
    count += block.data for block in blocks
    count
)