TimeboxedAggregator = require('./timeboxed-aggregator').TimeboxedAggregator

class Max
  constructor: (opts) ->
    @max = null
  push: (time, value) ->
    @max = value if @max == null or @max < value
  compute: ->
    @max

exports.all = Max


class TimeboxedMax extends TimeboxedAggregator
  recalculateBlockData: (blockData, value) ->
    if blockData is null or blockData < value then value else blockData
  computeFromBlocks: (blocks) ->
    max = null
    for block in blocks
      max = block.data if max == null or max < block.data
    max

exports.timeboxed = TimeboxedMax