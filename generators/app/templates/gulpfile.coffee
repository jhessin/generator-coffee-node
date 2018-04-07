gulp = require 'gulp'
coffee = require 'gulp-coffee'
cson = require 'gulp-cson'
sourcemaps = require 'gulp-sourcemaps'

gulp.task 'cson', ->
  gulp.src './src/**/*.cson'
    .pipe cson()
    .pipe gulp.dest './lib'

gulp.task 'coffee', ->
  gulp.src ['./src/**/*.coffee', './src/**/*.*.coffee']
    .pipe sourcemaps.init()
    .pipe coffee
      bare: true
      header: false
      transpile:
        presets: ['env']
    .pipe sourcemaps.write()
    .pipe gulp.dest './lib'

gulp.task 'watch', ['coffee', 'cson'], ->
  gulp.watch [
    './src/**/*.coffee', './src/**/*.*.coffee'
    './src/**/*.cson'], [ 'coffee', 'cson' ]

gulp.task 'default', [ 'cson', 'coffee' ]
