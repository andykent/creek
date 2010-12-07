http = require('http')
url = require('url')

exports.init = (agg, opts) -> 
  console.log("Rest Server Started")
  server = http.createServer (req, res) ->
    pathParts = url.parse(req.url).pathname.split('/')
    pathParts.shift()
    try
      result = if pathParts.length is 0
        JSON.stringify(agg.value())
      else if pathParts.length is 1
        JSON.stringify(agg.value(null, pathParts[0]))
      else
        JSON.stringify(agg.value(pathParts[1], pathParts[0]))
    catch e
      res.writeHead(500, 'Content-Type': 'application/json')
      res.end(JSON.stringify(message: "Unable to display requested data"))
      return
    res.writeHead(200, 'Content-Type': 'application/json')
    res.end(result)
  server.listen (opts.port or 8080), (opts.host or 'localhost')