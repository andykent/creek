http = require('http')
aggregator = require('./interface')

agg = aggregator.createAggregator()
agg.track 'popular', 
  aggregator: aggregator.min.timeboxed
  field:      'version'
  period:     5
  precision:  1

server = http.createServer (req, res) ->
  res.writeHead(200, {'Content-Type': 'text/plain'})
  res.end JSON.stringify(agg.value())

server.listen 8080, "127.0.0.1", ->
  jsonStream = require('./json-stream')
  jsonStream.eachRecord (record) ->
    # agg.push(record.site, new Date(record.timestamp), record)
    agg.push(new Date(record.timestamp), record)
