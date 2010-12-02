class JSONStream
  constructor: (recordHandler) ->
    @stream = process.openStdin()
    @stream.setEncoding('utf8')
    @patialData = ""
    @recordHandler = recordHandler
    @stream.on 'data', @dataHandler
  dataHandler: (chunk) =>
    @patialData += chunk
    parts = @patialData.split("\n")
    if parts[parts.length-1] == '' # this was a clean line break
      parts.pop()
      @patialData = ''
    else # this was a incomplete line, stash it
      @patialData = parts.pop()
    for line in parts
      try
        parsedLine = JSON.parse(line)
      catch e
        console.log("Failed to parse #{line}")
      @recordHandler(parsedLine) if parsedLine



exports.eachRecord = (handler) -> new JSONStream(handler)
