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
    @patialData = parts.pop() # last part will be an incomplete chunk or an empty string if we are lucky
    for chunk in parts
      @recordHandler(chunk) if chunk


exports.init = (agg, opts, handler) -> new ChunkedStream(opts, handler)
