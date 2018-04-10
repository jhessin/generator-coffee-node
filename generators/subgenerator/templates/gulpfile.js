// DO NOT MODIFY THIS FILE UNLESS YOU KNOW WHAT YOU ARE DOING
// It enables the use of ES6 syntax in your gulpfile.coffee file
require('coffee-babel')({
  transpile: {
    presets: ['env']
  },
})

module.exports = require('./gulpfile.coffee');
