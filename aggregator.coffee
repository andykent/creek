class Aggregator
  constructor: ->
    @aggregators = {}
  track: (name, opts) ->
    @aggregators[name] = {getValue: ((o) -> o[opts.field]), aggregator:(new opts.aggregator(opts))}
  push: (time, obj) ->
    for name, agg of @aggregators
      agg.aggregator.push(time, agg.getValue(obj))
  compute: (name) ->
    @aggregators[name].aggregator.compute()

class MeanAggregator
  constructor: (opts) ->
    @history = (opts.history || 60)*10
    @data = []
  push: (time, value) ->
    historyThreshold = (new Date().getTime())-@history
    @data.push( time:time, value:value )
    loop
      if @data.length > 0 and @data[0].time.getTime() < historyThreshold
        @data.shift()
      else
        break
  compute: ->
    sum = 0
    sum += fact.value for fact in @data
    sum / @data.length

exports.createAggregator = -> new Aggregator()
exports.MeanAggregator = MeanAggregator