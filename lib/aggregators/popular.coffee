timeboxedAggregator = require('../timeboxed-aggregator')

exports.timeboxed = timeboxedAggregator.buildTimeboxedAggregator 'Timeboxed Popular',
  init: (opts) ->
    @numberOfResultsToKeep = opts.top
    @numberOfResultsToKeep = 10 if @numberOfResultsToKeep is null
  defaultBlockValue: () -> {}
  closeBlock: (block) ->
    values = Object.keys(block.data)
    topValues = values.sort((a,b) -> block.data[b] - block.data[a])
    topValues = topValues.slice(0, @numberOfResultsToKeep) if numberOfResultsToKeep?
    topValues.reduce ((m,v) -> m[v] = block.data[v]; m), {}
  recalculateBlockData: (blockData, value) ->
    blockData[value] ?= 0
    blockData[value]++
    blockData
  computeFromBlocks: (blocks) ->
    completeBlocks = blocks.slice(0,blocks.length-1)
    foldBlocksTogether = (m,v) -> 
      for value, count of v.data
        m[value] = 0 unless m[value]?
        m[value] += count
      m
    foldedResults = completeBlocks.reduce foldBlocksTogether, {}
    topValues = Object.keys(foldedResults).sort((a,b) -> foldedResults[b] - foldedResults[a])
    topValues = topValues.slice(0, @numberOfResultsToKeep) if @numberOfResultsToKeep?
    topValues.reduce ((m,v) -> m.push(value:v, count:foldedResults[v]); m), []
