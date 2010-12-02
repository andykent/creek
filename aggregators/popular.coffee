timeboxedAggregator = require('../timeboxed-aggregator')

exports.timeboxed = timeboxedAggregator.buildTimeboxedAggregator
  defaultBlockValue: () -> {}
  closeBlock: (block) ->
    values = Object.keys(block.data)
    topValue = values.sort((a, b) -> block.data[b] - block.data[a])[0]
    {val:topValue, count: block.data[topValue]}
  recalculateBlockData: (blockData, value) ->
    blockData[value] ?= 0
    blockData[value] ++
    blockData
  computeFromBlocks: (blocks) ->
    completeBlocks = blocks.slice(0,blocks.length-1)
    blockValues = completeBlocks.map((b) -> b.data)
    blockValues.sort( (a,b) -> b.count - a.count )
    blockValues[0]?.val or null