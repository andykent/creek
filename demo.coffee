server = require('./server')

server.track 'alltime max', aggregator: server.modes.max.alltime, field:'count', period:5, precision: 1


# aggregator = require('./interface')
# agg = aggregator.createAggregator()
# 
# agg.track 'mean',          aggregator: aggregator.modes.mean.timeboxed,    field:'count', period:5, precision: 1
# agg.track 'max',           aggregator: aggregator.modes.max.timeboxed,     field:'count', period:5, precision: 1
# agg.track 'min',           aggregator: aggregator.modes.min.timeboxed,     field:'count', period:5, precision: 1
# agg.track 'sum',           aggregator: aggregator.modes.sum.timeboxed,     field:'count', period:5, precision: 1
# agg.track 'count',         aggregator: aggregator.modes.count.timeboxed,   field:'count', period:5, precision: 1
# agg.track 'popular',       aggregator: aggregator.modes.popular.timeboxed, field:'x',     period:5, precision: 1
# agg.track 'alltime mean',  aggregator: aggregator.modes.mean.alltime,      field:'count', period:5, precision: 1
# agg.track 'alltime max',   aggregator: aggregator.modes.max.alltime,       field:'count', period:5, precision: 1
# agg.track 'alltime min',   aggregator: aggregator.modes.min.alltime,       field:'count', period:5, precision: 1
# agg.track 'alltime sum',   aggregator: aggregator.modes.sum.alltime,       field:'count', period:5, precision: 1
# agg.track 'alltime count', aggregator: aggregator.modes.count.alltime,     field:'count', period:5, precision: 1
# 
# agg.on 'max', 'change', (newValue, oldValue) -> console.log("max changed from #{oldValue} to #{newValue}")
# 
# agg.push new Date(), count: 1,  x: 'hello'
# agg.push new Date(), count: 20, x: 'hello'
# 
# console.log(agg.value())
# 
# setTimeout (-> agg.push(new Date(), count: 2, x: 'hello')), 1100
# setTimeout (-> agg.push(new Date(), count: 4, x: 'hello')), 1150
# setTimeout (-> agg.push(new Date(), count: 4, x: ['x','x','x','x'])), 1200
# setTimeout (-> agg.push(new Date(), count: 6, x: 'hello')), 5500
# 
# process.on 'exit', -> console.log(agg.value())


# agg = aggregator.createBucketedAggregator()
# 
# agg.track 'mean',          aggregator: aggregator.mean.timeboxed,  field:'count', period:5, precision: 1
# agg.track 'max',           aggregator: aggregator.max.timeboxed,   field:'count', period:5, precision: 1
# agg.track 'min',           aggregator: aggregator.min.timeboxed,   field:'count', period:5, precision: 1
# agg.track 'total',         aggregator: aggregator.total.timeboxed, field:'count', period:5, precision: 1
# agg.track 'count',         aggregator: aggregator.count.timeboxed, field:'count', period:5, precision: 1
# agg.track 'alltime mean',  aggregator: aggregator.mean.alltime,    field:'count', period:5, precision: 1
# agg.track 'alltime max',   aggregator: aggregator.max.alltime,     field:'count', period:5, precision: 1
# agg.track 'alltime min',   aggregator: aggregator.min.alltime,     field:'count', period:5, precision: 1
# agg.track 'alltime total', aggregator: aggregator.total.alltime,   field:'count', period:5, precision: 1
# agg.track 'alltime count', aggregator: aggregator.count.alltime,   field:'count', period:5, precision: 1
# 
# agg.on 'max', 'change', (bucket, newValue, oldValue) -> console.log("max changed for #{bucket} from #{oldValue} to #{newValue}")
# 
# agg.push 'pass', new Date(), count: 1
# agg.push 'fail', new Date(), count: 2
# console.log(agg.value 'mean')
# console.log(agg.value 'mean', 'pass')
# 
# setTimeout (-> agg.push('pass', new Date(), count: 2)), 500
# setTimeout (-> agg.push('pass', new Date(), count: 5)), 5500
# setTimeout (-> agg.push('fail', new Date(), count: 80)), 5500
# 
# process.on 'exit', -> console.log(agg.value())