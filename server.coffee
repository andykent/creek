aggregator = require('./aggregator')

agg = aggregator.createAggregator()

agg.track 'avgRecordsPerSec', aggregator: aggregator.MeanAggregator, field:'count', history:60

agg.push new Date(), count: 1
agg.push new Date(), count: 2
console.log(agg.compute 'avgRecordsPerSec')

setTimeout (-> agg.push(new Date(), count: 2)), 500
setTimeout (-> agg.push(new Date(), count: 5)), 2000

process.on 'exit', -> console.log(agg.compute 'avgRecordsPerSec')



# jsonStream = require('./json-stream')
# jsonStream.eachRecord (record) ->



# http = require('http')
# server = http.createServer (req, res) ->
#   res.writeHead(200, {'Content-Type': 'text/plain'})
#   res.end('Hello World\n')  
# server.listen(8080, "127.0.0.1")