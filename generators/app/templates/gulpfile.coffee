import gulp from 'gulp'
import coffee from 'gulp-coffee'
import cson from 'gulp-cson'
import sourcemaps from 'gulp-sourcemaps'

paths =
  src:
    coffee: './src/**/{*.,*.*.}coffee'
    cson: './src/**/*.cson'
  dest: './lib'

compileCson = ->
  gulp.src paths.src.cson, since: gulp.lastRun(compileCson)
  .pipe cson()
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
  compileCson as cson
}

export watch = ->
  gulp.watch paths.src.coffee,
    ignoreInitial: false
    compileCoffee
  gulp.watch paths.src.cson,
    ignoreInitial: false
    compileCson

export default gulp.series compileCson, compileCoffee
