aggregator = require('./interface')

agg = aggregator.createBucketedAggregator()

agg.track 'mean',          aggregator: aggregator.mean.timeboxed,  field: ((o) -> if o.isBot then 100 else 0)
agg.track 'max',           aggregator: aggregator.max.timeboxed,   field: ((o) -> if o.isBot then 100 else 0)
agg.track 'min',           aggregator: aggregator.min.timeboxed,   field: ((o) -> if o.isBot then 100 else 0)
agg.track 'total',         aggregator: aggregator.total.timeboxed, field: ((o) -> if o.isBot then 100 else 0)
agg.track 'count',         aggregator: aggregator.count.timeboxed, field: ((o) -> if o.isBot then 100 else 0)
agg.track 'alltime mean',  aggregator: aggregator.mean.alltime,    field: ((o) -> if o.isBot then 100 else 0)
agg.track 'alltime max',   aggregator: aggregator.max.alltime,     field: ((o) -> if o.isBot then 100 else 0)
agg.track 'alltime min',   aggregator: aggregator.min.alltime,     field: ((o) -> if o.isBot then 100 else 0)
agg.track 'alltime total', aggregator: aggregator.total.alltime,   field: ((o) -> if o.isBot then 100 else 0)
agg.track 'alltime count', aggregator: aggregator.count.alltime,   field: ((o) -> if o.isBot then 100 else 0)

# agg.on 'alltime mean', 'change', (bucket, newValue, oldValue) ->
#   console.log("#{bucket} changed from #{oldValue} to #{newValue}")

process.on 'exit', -> console.log(agg.value())

jsonStream = require('./json-stream')
jsonStream.eachRecord (record) -> 
  agg.push(record.site, new Date(record.timestamp), record)
