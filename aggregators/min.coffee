class Min
  constructor: (opts) ->
    @min = null
  push: (time, value) ->
    @min = value if @min == null or @min > value
  compute: ->
    @min

exports.Min = Min