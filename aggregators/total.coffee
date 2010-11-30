class Total
  constructor: (opts) ->
    @total = 0
  push: (time, value) ->
    @total += value
  compute: ->
    @total

exports.Total = Total