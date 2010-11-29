class Aggregator
  constructor: ->
    @aggregators = {}
  track: (name, opts) ->
    @aggregators[name] = {getValue: ((o) -> o[opts.field]), aggregator:(new opts.aggregator(opts))}
  push: (time, obj) ->
    for name, agg of @aggregators
      val = agg.getValue(obj)
      agg.aggregator.push(time, val) if typeof val == 'number'
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
  compute: (name, bucket) ->
    if bucket
      @aggregators[bucket].compute(name)
    else
      ret = {}
      for bucket, agg of @aggregators
        ret[bucket] = agg.compute(name)
      ret
  buckets: ->
    Object.keys(@aggregators)



exports.createAggregator = -> new Aggregator()
exports.createBucketedAggregator = -> new LazyBucketedAggregator()

exports.Mean = require('./aggregators/mean').Mean
exports.TimeboxedMean = require('./aggregators/timeboxed-mean').TimeboxedMean
exports.Min = require('./aggregators/min').Min
exports.Max = require('./aggregators/max').Max