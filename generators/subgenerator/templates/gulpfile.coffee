import gulp from 'gulp'
import coffee from 'gulp-coffee'
import sourcemaps from 'gulp-sourcemaps'
import del from 'del'

paths =
  src:
    coffee: './src/**/*.coffee'
    cson: './src/**/*.cson'
  dest: './lib'

copyCson = ->
  gulp.src paths.src.cson, since: gulp.lastRun(copyCson)
  .pipe gulp.dest paths.dest

compileCoffee = ->
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

export {
  compileCoffee as coffee
  copyCson as cson
}

export clean = ->
  del [
    'lib'
  ]

export watch = ->
  gulp.watch paths.src.coffee,
    ignoreInitial: false
    compileCoffee
  gulp.watch paths.src.cson,
    ignoreInitial: false
    copyCson

export default gulp.series copyCson, compileCoffee
