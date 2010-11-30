TimeboxedAggregator = require('./timeboxed-aggregator').TimeboxedAggregator

class Total
  constructor: (opts) ->
    @total = 0
  push: (time, value) ->
    @total += value
  compute: ->
    @total

exports.all = Total


class TimeboxedTotal extends TimeboxedAggregator
  recalculateBlockData: (blockData, value) ->
    blockData += value
  computeFromBlocks: (blocks) ->
    total = 0
    total += block.data for block in blocks
    total

exports.timeboxed = TimeboxedTotal