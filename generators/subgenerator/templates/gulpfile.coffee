import gulp from 'gulp'
import filter from 'gulp-filter'
import coffee from 'gulp-coffee'
import sourcemaps from 'gulp-sourcemaps'
import del from 'del'

coffeeOptions =
  bare: true
  header: false
  transpile:
    presets: ['env']

paths =
  src: './src/**/*.*'
  filter: filter ['**/*.coffee'], restore: true
  dest: './lib'

export compile = ->
  gulp.src paths.src
  .pipe paths.filter
  .pipe sourcemaps.init()
  .pipe coffee coffeeOptions
  .pipe sourcemaps.write()
  .pipe paths.filter.restore
  .pipe gulp.dest paths.dest

export clean = ->
  del [
    'lib'
  ]

export watch = ->
  gulp.watch paths.src,
    ignoreInitial: false
    compile

export default gulp.series clean, compile
