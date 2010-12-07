class ChunkedStream
  constructor: (opts, recordHandler) ->
    @seperator = opts.seperatedBy or "\n"
    @stream = process.openStdin()
    @stream.setEncoding('utf8')
    @patialData = ""
    @recordHandler = recordHandler
    @stream.on 'data', @dataHandler
  dataHandler: (data) =>
    @patialData += data
    parts = @patialData.split(@seperator)
    if parts[parts.length-1] == '' # this was a clean chunk break
      parts.pop()
      @patialData = ''
    else # this was a incomplete chunk, stash it
      @patialData = parts.pop()
    for chunk in parts
      @recordHandler(chunk) if chunk


exports.init = (agg, opts, handler) -> new ChunkedStream(opts, handler)
