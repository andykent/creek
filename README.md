[![build status](https://secure.travis-ci.org/andykent/creek.png)](http://travis-ci.org/andykent/creek)
**THIS PROJECT ISN'T ACTIVELY MAINTAINED**
**https://github.com/andykent/river is where all the action is at**

When you've got a hosepipe, what you need is a Creek!
=====================================================
Creek is a dead simple way to run performant summary analysis over time series data. Creek is written in coffee-script and has only been tested with node 0.2.5.

Current Status
--------------
It's early days for the project and there may be some warts however Creek is currently used in production at Forward to analyse over 35 million messages per day.

The command line tool and configuration interface is fairly stable however the code level interfaces not so much.

Hello World Example
-------------------

Get the code with either `npm install creek` or clone this repo and either add creek to your path or use ./bin/creek in place.

then create a file somewhere called `hello.creek` containing the following...

    parser 'words'
    interface 'rest'
    track 'unique-words', aggregator: distinct.alltime
    track 'count', aggregator: count.alltime

Then run `echo 'hello world from creek' | creek hello.creek` 

To see Creek in action run `curl "http://localhost:8080/"` from another window.

Twitter Example
---------------

As with the hello world example above but using this config instead...

    parser 'json', seperatedBy: '\r'
    interface 'rest'
    
    track 'languages-seen'
     aggregator: distinct.alltime
     field: (o) -> if o.user then o.user.lang else undefined
     
    track 'popular-words'
      aggregator: popular.timeboxed
      field: (o) -> if o.text then o.text.toLowerCase().split(' ') else undefined
      period: 60
      precision: 5
      top: 10
      before: (v) -> if v and v.length > 4 then v else undefined
      
    track 'popular-urls'
      aggregator: popular.timeboxed
      field: (o) -> if o.text then o.text.split(' ') else undefined
      period: 60*30
      precision: 60
      top: 5
      before: (v) -> if v and v.indexOf('http://') is 0 then v else undefined

Then run `curl http://stream.twitter.com/1/statuses/sample.json -u USERNAME:PASSWORD | creek twitter.creek` and visit `http://localhost:8080/`

Parsers
-------
You must choose a parser, the currently available options are...

* words - this pushes each word to the aggregator using the current timestamp
* json - expects line separated JSON objects
* chunked - this is a generic parser which can chunk a stream based on any string or regex
* zeromq - allows subscription to a zeromq channel rather than input on stdin.

Currently all the parsers expect utf8 or a subset thereof.

Interfaces
----------
There is currently only one interface available...

* rest - this makes a JSON rest api available running on localhost:8080 by default.

Aggregators
-----------
The currently available aggregators are...

* count.alltime
* count.timeboxed
* distinct.alltime
* distinct.timeboxed
* max.alltime
* max.timeboxed
* mean.alltime
* mean.timeboxed
* min.alltime
* min.timeboxed
* popular.timeboxed
* recent.limited
* sum.alltime
* sum.timeboxed

All aggregators support `field` and `before` options and timeboxed ones also support `period` and `precision` settings. 

* field - defaults to the whole object, can be a string in which case it uses that key on the object, or an integer in which case it uses that as a constant value, or a function which takes an object and returns a value to be used.
* before - a function that takes each chunks field right before it is about to be pushed to the aggregator, you should return the original value, a modified value or undefined if you would like this chunk to be skipped.
* period - this is the period in seconds over which you would like the timeboxed aggregation to run. A value of 60 will keep track of the value over the last rolling 1 min window. The default value is 60 seconds.
* precision - the accuracy of the rolling time window specified in seconds. I general lower the value used here the more memory will be required. The default value is 1 second. 

Notes
-----
Please note that the current aggregator implementations are fairly immature and they may not be optimal in terms of RAM or CPU usage at this point. 
What I can say though is they are efficient enough for most use cases and Creek can comfortably handle dozens of aggregators running across 1,000s of records per second.

If anyone would like to contribute interfaces, parsers or aggregators they would be gladly received.
