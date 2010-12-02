class CompoundAggregator
  constructor: ->
    @aggregators = {}
  track: (name, opts) ->
    getValue = switch typeof opts.field
      when 'string' then ((o) -> o[opts.field])
      when 'number' then ((o) -> opts.field)
      when 'function' then ((o) -> opts.field(o))
      else ((o) -> o)
    @aggregators[name] = {getValue:getValue, aggregator:opts.aggregator(opts)}
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
      agg.aggregator.push(time, val)
  value: (name) ->
    if typeof name is 'string'
      console.log("Aggregation '#{name}' does not exist!") unless @aggregators[name]
      @aggregators[name].aggregator.value()
    else
      ret = {}
      for name, agg of @aggregators
        ret[name] = agg.aggregator.value()
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
      for e in @events
        @aggregators[bucket].on e.name, e.event, (newValue, oldValue) -> e.callback(bucket, newValue, oldValue)
    @aggregators[bucket].push(time, obj)
  value: (name, bucket) ->
    if bucket
      @aggregators[bucket].value(name)
    else
      ret = {}
      for bucket, agg of @aggregators
        ret[bucket] = agg.value(name)
      ret
  buckets: ->
    Object.keys(@aggregators)

exports.createAggregator = -> new CompoundAggregator()
exports.createBucketedAggregator = -> new LazyBucketedAggregator()

exports.mean = require('./aggregators/mean')
exports.min = require('./aggregators/min')
exports.max = require('./aggregators/max')
exports.count = require('./aggregators/count')
exports.sum = require('./aggregators/sum')
exports.popular = require('./aggregators/popular')
