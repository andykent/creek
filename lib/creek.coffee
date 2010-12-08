exports.aggregator = require('./aggregator')
exports.compoundAggregator = require('./compound-aggregator')
exports.lazyBucketedAggregator = require('./lazy-bucketed-aggregator')

exports.aggregators = 
  count:    require('./aggregators/count')
  distinct: require('./aggregators/distinct')
  max:      require('./aggregators/max')
  mean:     require('./aggregators/mean')
  min:      require('./aggregators/min')
  popular:  require('./aggregators/popular')
  recent:   require('./aggregators/recent')
  sum:      require('./aggregators/sum')
