gulp = require 'gulp'
coffee = require 'gulp-coffee'
cson = require 'gulp-cson'
sourcemaps = require 'gulp-sourcemaps'

exports.cson = compileCson = ->
  gulp.src './src/**/*.cson', since: gulp.lastRun(compileCson)
  .pipe cson()
  .pipe gulp.dest './lib'

exports.coffee = compileCoffee = ->
  gulp.src ['./src/**/*.coffee', './src/**/*.*.coffee'],
    since: gulp.lastRun(compileCoffee)
  .pipe sourcemaps.init()
  .pipe coffee
    bare: true
    header: false
    transpile:
      presets: ['env']
  .pipe sourcemaps.write()
  .pipe gulp.dest './lib'



exports.watch = -> gulp.watch([
  './src/**/*.coffee', './src/**/*.*.coffee'
  './src/**/*.cson'],
  ignoreInitial: false
  gulp.series(compileCson, compileCoffee))

exports.default = gulp.series compileCson, compileCoffee
