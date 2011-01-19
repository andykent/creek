aggregator = require('../aggregator')
timeboxedAggregator = require('../timeboxed-aggregator')


exports.alltime = aggregator.buildAggregator 'Alltime Distinct',
  init: (opts) -> @records = []
  push: (time, value) -> @records.push(value) if @records.indexOf(value) is -1
  compute: -> @records


exports.timeboxed = timeboxedAggregator.buildTimeboxedAggregator 'Timeboxed Distinct',
  recalculateBlockData: (blockData, value) ->
    blockData += value
    blockData.push(value) if blockData.indexOf(value) is -1
  computeFromBlocks: (blocks) ->
    uniques = []
    for block in blocks
      for value in block
        uniques.push(value) if uniques.indexOf(value) is -1
    uniques