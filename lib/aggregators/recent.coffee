aggregator = require('../aggregator')

exports.limited = aggregator.buildAggregator 'Most Recent',
  init: (opts) -> 
    @count = opts.count or 10
    @items = []
  push: (time, value) ->
    @items.reverse()
    @items.push(value)
    @items.shift() if @items.length > @count
    @items.reverse()
  compute: -> @items