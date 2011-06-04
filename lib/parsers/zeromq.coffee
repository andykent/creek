zeromq = require('zeromq')


exports.init = (agg, opts, handler) ->
  socket = zeromq.createSocket('sub')
  socket.connect(opts.url)
  socket.subscribe(opts.channel) if opts.channel
  socket.on 'message', (ch, data) -> 
    if opts.as is 'json'
      handler(JSON.parse(data.toString('utf8')))
    else
      handler(data.toString('utf8'))