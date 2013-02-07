creek = require('./creek')

agg = creek.lazyBucketedAggregator.create()

publicInterface = {}

publicInterface.track = (name, opts) -> agg.track(name, opts)

for name, code of creek.aggregators
  publicInterface[name] = code

publicInterface.interface = (interfaceName, opts) ->
  opts ?= {}
  require("./interfaces/#{interfaceName}").init(agg, opts)

publicInterface.parser = (parserName, opts) ->
  opts ?= {}
  require("./parsers/#{parserName}").init agg, opts, (record) -> 
    bucket = if opts.bucketedBy?
      if typeof opts.bucketedBy is 'string'
        record[opts.bucketedBy]
      else
        opts.bucketedBy(record)
    else
      null
    timestamp = if opts.timestampedBy?
      if typeof opts.timestampedBy is 'string'
        new Date(record[opts.timestampedBy]) 
      else
        opts.timestampedBy(record)
    else 
      new Date()
    agg.push((bucket or 'default'), timestamp, record)

exports.boot = (configFile) ->
  Script = require('vm').Script
  code = require('fs').readFileSync(configFile, 'utf8')
  jsCode = require('coffee-script').compile(code)
  Script.runInNewContext(jsCode, publicInterface, configFile)