http = require('http')
url = require('url')

exports.init = (agg, opts) ->
  console.log("Rest Server Started")
  server = http.createServer (req, res) ->
    pathParts = url.parse(req.url).pathname.split('/')
    pathParts.shift()
    buildResponse = (obj) ->
      callback = url.parse(req.url, true).query?.callback
      if callback?
        "#{callback}(#{JSON.stringify(obj)});"
      else
        JSON.stringify(obj)
    try
      result = if pathParts.length is 0
        buildResponse(agg.value())
      else if pathParts.length is 1
        buildResponse(agg.value(null, pathParts[0]))
      else
        buildResponse(agg.value(pathParts[1], pathParts[0]))
    catch e
      res.writeHead(500, 'Content-Type': 'application/json; charset=utf-8')
      res.end(buildResponse(message: "Unable to display requested data"))
      return
    res.writeHead(200, 'Content-Type': 'application/json')
    res.end(result)
  server.listen (opts.port or 8080), (opts.host or 'localhost')