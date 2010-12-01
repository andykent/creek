aggregator = require('./interface')

agg = aggregator.createAggregator()

agg.track 'mean',          aggregator: aggregator.mean.timeboxed,  field:'count', period:5, precision: 1
agg.track 'max',           aggregator: aggregator.max.timeboxed,   field:'count', period:5, precision: 1
agg.track 'min',           aggregator: aggregator.min.timeboxed,   field:'count', period:5, precision: 1
agg.track 'total',         aggregator: aggregator.total.timeboxed, field:'count', period:5, precision: 1
agg.track 'count',         aggregator: aggregator.count.timeboxed, field:'count', period:5, precision: 1
agg.track 'alltime mean',  aggregator: aggregator.mean.alltime,    field:'count', period:5, precision: 1
agg.track 'alltime max',   aggregator: aggregator.max.alltime,     field:'count', period:5, precision: 1
agg.track 'alltime min',   aggregator: aggregator.min.alltime,     field:'count', period:5, precision: 1
agg.track 'alltime total', aggregator: aggregator.total.alltime,   field:'count', period:5, precision: 1
agg.track 'alltime count', aggregator: aggregator.count.alltime,   field:'count', period:5, precision: 1

# agg.on 'max', 'change', (newValue, oldValue) -> console.log("max changed from #{oldValue} to #{newValue}")

agg.push new Date(), count: 1
agg.push new Date(), count: 20

console.log(agg.compute())

setTimeout (-> agg.push(new Date(), count: 2)), 1100
setTimeout (-> agg.push(new Date(), count: 4)), 1200
setTimeout (-> agg.push(new Date(), count: 6)), 5500

process.on 'exit', -> console.log(agg.compute())


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
# agg.push 'pass', new Date(), count: 1
# agg.push 'fail', new Date(), count: 2
# console.log(agg.compute 'mean')
# console.log(agg.compute 'mean', 'pass')
# 
# setTimeout (-> agg.push('pass', new Date(), count: 2)), 500
# setTimeout (-> agg.push('pass', new Date(), count: 5)), 2000
# 
# process.on 'exit', -> console.log(agg.compute())



# jsonStream = require('./json-stream')
# jsonStream.eachRecord (record) ->



# http = require('http')
# server = http.createServer (req, res) ->
#   res.writeHead(200, {'Content-Type': 'text/plain'})
#   res.end('Hello World\n')  
# server.listen(8080, "127.0.0.1")