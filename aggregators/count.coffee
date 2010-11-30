class Count
  constructor: (opts) ->
    @count = 0
  push: (time, value) ->
    @count ++
  compute: ->
    @count

exports.Count = Count