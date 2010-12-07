chunkedStream = require('./chunked')

exports.init = (agg, opts, handler) ->
  chunkedStream.init agg, opts, (chunk) ->
    try
      parsedLine = JSON.parse(chunk)
    catch e
    handler(parsedLine) if parsedLine
    
