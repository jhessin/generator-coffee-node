import gulp from 'gulp'
import filter from 'gulp-filter'
import coffee from 'gulp-coffee'
import sourcemaps from 'gulp-sourcemaps'
import del from 'del'

paths =
  src: './src/**/*.*'
  dest: './lib'

export compile = ->
  f = filter ['*.coffee'], restore: true
  gulp.src paths.src,
    since: gulp.lastRun(compile)
  .pipe f
  .pipe sourcemaps.init()
  .pipe coffee
    bare: true
    header: false
    transpile:
      presets: ['env']
  .pipe sourcemaps.write()
  .pipe f.restore
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
