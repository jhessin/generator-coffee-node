require 'fs-cson/register' # this is required for cson
data = require './data.cson' # cson must be required not imported
###
Anything else can use ES6. You can customize the options passed to
coffeescript from the gulpfile.coffee file.
###

console.log JSON.stringify data

exports = module.exports = data

export { exports as default}
