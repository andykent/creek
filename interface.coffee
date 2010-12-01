class CompoundAggregator
  constructor: ->
    @aggregators = {}
  track: (name, opts) ->
    @aggregators[name] = {getValue: ((o) -> o[opts.field]), aggregator:opts.aggregator(opts)}
  on: (name, event, callback) ->
    if arguments.length == 3
      @aggregators[name].aggregator.on(event, callback)
    else
      event = name
      callback = event
      agg.aggregator.on(event, callback) for name, agg of @aggregators
  push: (time, obj) ->
    for name, agg of @aggregators
      val = agg.getValue(obj)
      agg.aggregator.push(time, val) if typeof val == 'number'
  compute: (name) ->
    if typeof name is 'string'
      console.log("Aggregation '#{name}' does not exist!") unless @aggregators[name]
      @aggregators[name].aggregator.compute()
    else
      ret = {}
      for name, agg of @aggregators
        ret[name] = agg.aggregator.compute()
      ret

class LazyBucketedAggregator
  constructor: -> 
    @aggregatorOpts = {}
    @aggregators = {}
    @events = []
  track: (name, opts) ->
    @aggregatorOpts[name] = opts
  on: (name, event, callback) ->
    if arguments.length == 2
      event = name
      callback = event
      name = null
    @events.push( name:name, event:event, callback:callback )
  push: (bucket, time, obj) ->
    unless @aggregators[bucket]
      @aggregators[bucket] = new CompoundAggregator()
      @aggregators[bucket].track(name, opts) for name, opts of @aggregatorOpts
      console.log("e: #{@events}")
      for e in @events
        console.log("adding #{bucket} - #{e.name} -> #{e.event}")
        @aggregators[bucket].on e.name, e.event, (newValue, oldValue) -> e.callback(bucket, newValue, oldValue)
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



exports.createAggregator = -> new CompoundAggregator()
exports.createBucketedAggregator = -> new LazyBucketedAggregator()

exports.mean = require('./aggregators/mean')
exports.min = require('./aggregators/min')
exports.max = require('./aggregators/max')
exports.count = require('./aggregators/count')
exports.total = require('./aggregators/total')
