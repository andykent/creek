http = require('http')
io = require('socket.io')

exports.init = (agg, opts) ->
  server = http.createServer (req, res) ->
   res.writeHead(200, {'Content-Type': 'text/html'})
   res.write('<h1>Hello world</h1>')
   res.end()
  
  server.listen(8888)
  
  socket = io.listen(server)
  
  agg.on 'change', (newValue) ->
    socket.broadcast(JSON.stringify(newValue))
