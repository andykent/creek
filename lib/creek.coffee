exports.aggregator = require('./aggregator')
exports.compoundAggregator = require('./compound-aggregator')
exports.lazyBucketedAggregator = require('./lazy-bucketed-aggregator')

exports.aggregators = 
  mean: require('./aggregators/mean')
  min: require('./aggregators/min')
  max: require('./aggregators/max')
  count: require('./aggregators/count')
  sum: require('./aggregators/sum')
  popular: require('./aggregators/popular')
  distinct: require('./aggregators/distinct')
  recent: require('./aggregators/recent')