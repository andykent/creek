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

class LazyBucketedAggregator
  constructor: -> 
    @aggregatorOpts = {}
    @aggregators = {}
  track: (name, opts) ->
    @aggregatorOpts[name] = opts
  push: (bucket, time, obj) ->
    unless @aggregators[bucket]
      @aggregators[bucket] = new Aggregator()
      @aggregators[bucket].track(name, opts) for name, opts of @aggregatorOpts
    @aggregators[bucket].push(time, obj)
  compute: (bucket, name) ->
    @aggregators[bucket].compute(name)
  buckets: ->
    Object.keys(@aggregators)

class exports.Mean
  constructor: (opts) ->
    @count = 0
    @total = 0
  push: (time, value) ->
    @count++
    @total += value
  compute: ->
    @total / @count
    
class exports.TimeboxedMean
  constructor: (opts) ->
    @period = (opts.period or 60) * 1000
    @data = []
  push: (time, value) ->
    periodThreshold = (new Date().getTime())-@period
    @data.push( time:time, value:value )
    loop
      if @data.length > 0 and @data[0].time.getTime() < periodThreshold
        @data.shift()
      else
        break
  compute: ->
    sum = 0
    sum += fact.value for fact in @data
    sum / @data.length

exports.createAggregator = -> new Aggregator()
exports.createBucketedAggregator = -> new LazyBucketedAggregator()