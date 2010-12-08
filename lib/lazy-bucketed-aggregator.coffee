compoundAggregator = require('./compound-aggregator')

class LazyBucketedAggregator
  constructor: -> 
    @aggregatorOpts = {}
    @aggregators = {}
    @events = []
  track: (name, opts) ->
    @aggregatorOpts[name] = opts
    console.log("Lazy Tracking '#{name}' with #{JSON.stringify(opts)}")
  on: (name, event, callback) ->
    if arguments.length == 2
      event = name
      callback = event
      name = null
    @events.push( name:name, event:event, callback:callback )
  push: (bucket, time, obj) ->
    unless @aggregators[bucket]
      @aggregators[bucket] = compoundAggregator.create()
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

exports.create = -> new LazyBucketedAggregator()