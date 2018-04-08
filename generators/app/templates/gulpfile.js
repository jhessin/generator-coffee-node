// DO NOT MODIFY THIS FILE UNLESS YOU KNOW WHAT YOU ARE DOING
// It enables the use of ES6 syntax in your gulpfile.coffee file

const CoffeeScript = require('coffeescript');

const { compile } = CoffeeScript;
CoffeeScript.compile = (file, options) => (
  compile(file, Object.assign(options, {
    transpile: {
      presets: ['env']
    },
  }))
);
CoffeeScript.register();

module.exports = require('./gulpfile.coffee');
