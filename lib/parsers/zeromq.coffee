zeromq = require('zeromq')


exports.init = (agg, opts, handler) ->
  socket = zeromq.createSocket('sub')
  socket.connect(opts.url)
  socket.subscribe(opts.channel) if opts.channel
  socket.on 'message', (ch, data) -> 
    utf8Data = data.toString('utf8')
    if opts.as is 'json'
      try
        handler(JSON.parse(utf8Data))
      catch e
        console.log("ERR: failed to JSON parse - #{utf8Data}")
    else
      handler(utf8Data)