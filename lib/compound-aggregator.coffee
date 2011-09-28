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
    console.log("Tracking '#{@aggregators[name].aggregator.name}' as '#{name}' with #{JSON.stringify(opts)}")
  on: (name, event, callback) ->
    if arguments.length == 3
      @aggregators[name].aggregator.on(event, callback)
    else
      callback = event
      event = name
      for name, agg of @aggregators
        ((name) -> agg.aggregator.on(event, (newValue, oldValue) -> callback(newValue, oldValue, name)))(name)
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

exports.create = -> new CompoundAggregator()
