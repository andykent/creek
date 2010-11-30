TimeboxedAggregator = require('./timeboxed-aggregator').TimeboxedAggregator

class Count
  constructor: (opts) ->
    @count = 0
  push: (time, value) ->
    @count ++
  compute: ->
    @count

exports.all = Count


class TimeboxedCount extends TimeboxedAggregator
  recalculateBlockData: (blockData, value) ->
    blockData + 1
  computeFromBlocks: (blocks) ->
    count = 0
    count += block.data for block in blocks
    count

exports.timeboxed = TimeboxedCount