class Max
  constructor: (opts) ->
    @max = null
  push: (time, value) ->
    @max = value if @max == null or @max < value
  compute: ->
    @max

exports.Max = Max