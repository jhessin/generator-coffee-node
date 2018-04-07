gulp = require 'gulp'
coffee = require 'gulp-coffee'
cson = require 'gulp-cson'
sourcemaps = require 'gulp-sourcemaps'

paths =
  src:
    coffee: './src/**/{*.,*.*.}coffee'
    cson: './src/**/*.cson'
  dest: './lib'

exports.cson = compileCson = ->
  gulp.src paths.src.cson, since: gulp.lastRun(compileCson)
  .pipe cson()
  .pipe gulp.dest paths.dest

exports.coffee = compileCoffee = ->
  gulp.src paths.src.coffee,
    since: gulp.lastRun(compileCoffee)
  .pipe sourcemaps.init()
  .pipe coffee
    bare: true
    header: false
    transpile:
      presets: ['env']
  .pipe sourcemaps.write()
  .pipe gulp.dest paths.dest

exports.watch = watch = ->
  gulp.watch paths.src.coffee,
    ignoreInitial: false
    compileCoffee
  gulp.watch paths.src.cson,
    ignoreInitial: false
    compileCson

exports.default = gulp.series compileCson, compileCoffee
