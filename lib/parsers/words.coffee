chunkedStream = require('./chunked')

exports.init = (agg, opts, handler) ->
  opts.seperatedBy = /\W/
  chunkedStream.init agg, opts, (chunk) ->
    handler(chunk)