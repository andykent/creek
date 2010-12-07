class JSONStream
  constructor: (opts, recordHandler) ->
    @seperator = opts.seperatedBy or "\n"
    @stream = process.openStdin()
    @stream.setEncoding('utf8')
    @patialData = ""
    @recordHandler = recordHandler
    @stream.on 'data', @dataHandler
  dataHandler: (chunk) =>
    @patialData += chunk
    parts = @patialData.split(@seperator)
    if parts[parts.length-1] == '' # this was a clean line break
      parts.pop()
      @patialData = ''
    else # this was a incomplete line, stash it
      @patialData = parts.pop()
    for line in parts
      try
        parsedLine = JSON.parse(line)
      catch e
      @recordHandler(parsedLine) if parsedLine



exports.init = (agg, opts, handler) -> new JSONStream(opts, handler)
