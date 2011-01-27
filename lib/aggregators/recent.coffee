aggregator = require('../aggregator')

exports.limited = aggregator.buildAggregator 'Most Recent',
  init: (opts) -> 
    @count = opts.count or 10
    @items = []
  push: (time, value) ->
    @items.unshift(value)
    @items.pop() if @items.length > @count
  compute: -> @items