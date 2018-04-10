path = require 'path'
Generator = require 'yeoman-generator'
chalk = require 'chalk'

module.exports = class extends Generator
  writing: ->
    @fs.extendJSON @destinationPath('package.json'), {
      scripts:
        start: 'gulp && node .'
        watch: 'gulp watch'
        pretest: 'coffeelint src'
        test: 'mocha'
        prepublishOnly:
          'nsp check && gulp'
      'lint-staged':
        '*.coffee': [
          'coffeelint',
          'git add'
        ]
    }

    @log chalk.yellow('COPYING COFFEESCRIPT FILES PLEASE WAIT...')
    @fs.copy @templatePath('.vscode'),
      @destinationPath('.vscode')
    @fs.copy @templatePath('src'),
      @destinationPath('src')
    @fs.copy @templatePath('test'),
      @destinationPath('test')

    @fs.copy @templatePath('.gitignore'),
      @destinationPath('.gitignore')
    @fs.copy @templatePath('.npmignore'),
      @destinationPath('.npmignore')
    @fs.copy @templatePath('coffeelint.json'),
      @destinationPath('coffeelint.json')
    @fs.copy @templatePath('gulpfile.coffee'),
      @destinationPath('gulpfile.coffee')
    @fs.copy @templatePath('gulpfile.js'),
      @destinationPath('gulpfile.js')
    @log chalk.green('DONE!')

  install: ->
    pkgs = [
      'coffeescript', 'gulp@next', 'coffee-babel'
      'babel-core', 'babel-preset-env'
      'gulp-coffee', 'gulp-cson'
      'gulp-sourcemaps', 'mocha', 'fs-cson'
    ]
    @yarnInstall pkgs,
      dev: true
    .then (yarnError)=>
      if yarnError
        @npmInstall pkgs, dev: true
        .then (npmError)->
          if npmError
            throw new Error 'Yarn or NPM required'
    return

  end: ->
    @spawnCommandSync 'git', [ 'init' ]
    @spawnCommandSync 'git', [ 'add', '.' ]
    @spawnCommandSync 'git', [ 'commit', '-m', 'Baseline']
