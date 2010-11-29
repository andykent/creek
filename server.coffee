aggregator = require('./aggregator')

agg = aggregator.createAggregator()

agg.track 'avgRecordsPerSec', aggregator: aggregator.TimeboxedMean, field:'count', period:5, precision: 1

agg.push new Date(), count: 1
agg.push new Date(), count: 2
console.log(agg.compute 'avgRecordsPerSec')

setTimeout (-> agg.push(new Date(), count: 2)), 1100
setTimeout (-> agg.push(new Date(), count: 4)), 1200
setTimeout (-> agg.push(new Date(), count: 6)), 5500

process.on 'exit', -> console.log(agg.compute 'avgRecordsPerSec')



# agg = aggregator.createBucketedAggregator()
# 
# agg.track 'avgRecordsPerSec', aggregator: aggregator.MeanAggregator, field:'count', history:60
# 
# agg.push 'pass', new Date(), count: 1
# agg.push 'fail', new Date(), count: 2
# console.log(agg.compute 'pass', 'avgRecordsPerSec')
# console.log(agg.compute 'fail', 'avgRecordsPerSec')
# 
# setTimeout (-> agg.push('pass', new Date(), count: 2)), 500
# setTimeout (-> agg.push('pass', new Date(), count: 5)), 2000
# 
# process.on 'exit', -> console.log(agg.compute 'pass', 'avgRecordsPerSec')



# jsonStream = require('./json-stream')
# jsonStream.eachRecord (record) ->



# http = require('http')
# server = http.createServer (req, res) ->
#   res.writeHead(200, {'Content-Type': 'text/plain'})
#   res.end('Hello World\n')  
# server.listen(8080, "127.0.0.1")