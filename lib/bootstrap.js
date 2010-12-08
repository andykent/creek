require('coffee-script')
var creek = require('./creek')
for(var key in creek) {
  exports[key] = creek[key]
}
