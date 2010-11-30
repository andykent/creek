TimeboxedAggregator = require('./timeboxed-aggregator').TimeboxedAggregator

class Mean
  constructor: (opts) ->
    @count = 0
    @total = 0
  push: (time, value) ->
    @count++
    @total += value
  compute: ->
    @total / @count

exports.all = Mean


class TimeboxedMean extends TimeboxedAggregator
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
    total / count

exports.timeboxed = TimeboxedMean