class Mean
  constructor: (opts) ->
    @count = 0
    @total = 0
  push: (time, value) ->
    @count++
    @total += value
  compute: ->
    @total / @count

exports.Mean = Mean