aggregator = require('./aggregator')

agg = aggregator.createBucketedAggregator()

agg.track 'mean',          aggregator: aggregator.mean.timeboxed,  field:'count'
agg.track 'max',           aggregator: aggregator.max.timeboxed,   field:'count'
agg.track 'min',           aggregator: aggregator.min.timeboxed,   field:'count'
agg.track 'total',         aggregator: aggregator.total.timeboxed, field:'count'
agg.track 'count',         aggregator: aggregator.count.timeboxed, field:'count'
agg.track 'alltime mean',  aggregator: aggregator.mean.alltime,    field:'count'
agg.track 'alltime max',   aggregator: aggregator.max.alltime,     field:'count'
agg.track 'alltime min',   aggregator: aggregator.min.alltime,     field:'count'
agg.track 'alltime total', aggregator: aggregator.total.alltime,   field:'count'
agg.track 'alltime count', aggregator: aggregator.count.alltime,   field:'count'

process.on 'exit', -> console.log(agg.compute())

jsonStream = require('./json-stream')
jsonStream.eachRecord (record) -> agg.push(record.site, new Date(record.timestamp), record)
