TimeboxedAggregator = require('./timeboxed-aggregator').TimeboxedAggregator

class Min
  constructor: (opts) ->
    @min = null
  push: (time, value) ->
    @min = value if @min == null or @min > value
  compute: ->
    @min

exports.all = Min


class TimeboxedMin extends TimeboxedAggregator
  recalculateBlockData: (blockData, value) ->
    if blockData is null or blockData > value then value else blockData
  computeFromBlocks: (blocks) ->
    min = null
    for block in blocks
      min = block.data if min == null or min > block.data
    min

exports.timeboxed = TimeboxedMin