path = require 'path'
Generator = require 'yeoman-generator'
askName = require 'inquirer-npm-name'
_ = require 'lodash'
mkdirp = require 'mkdirp'
chalk = require 'chalk'

module.exports = class extends Generator
  constructor: (args, opts)->
    super(args, opts)

    @argument 'name',
      type: String
      required: false

    if @options.name?
      @props = @options
    else
      @props = {}
    return

  prompting: ->
    askName {
      name: 'name'
      message: 'Your generator name'
      default: @props.name ? path.basename(process.cwd())
    }, this
    .then (props) =>
      @props.name = props.name

  writing: ->
    if path.basename(@destinationPath()) isnt @props.name
      @log "Your generator must be inside a folder named #{@props.name}\n\
      I'll automatically create this folder."
      mkdirp @props.name
      @destinationRoot @destinationPath(@props.name)
    readmeTpl = _.template @fs.read(@templatePath('README.md'))

    @composeWith require.resolve('generator-node/generators/app'), {
      name: @props.name
      boilerplate: false
      projectRoot: 'lib'
      skipInstall: true
      readme: readmeTpl @props
    }

    @fs.extendJSON @destinationPath('package.json'), {
      scripts:
        start: 'gulp && node .'
        watch: 'gulp watch'
        pretest: 'coffeelint src && gulp'
        prepublishOnly:
          'nsp check && gulp'
      'lint-staged':
        '*.coffee': [
          'coffeelint',
          'git add'
        ]
    }

    @fs.copy @templatePath('gulpfile.coffee'),
      @destinationPath('gulpfile.coffee')
    @fs.copy @templatePath('gulpfile.js'),
      @destinationPath('gulpfile.js')
    @fs.copy @templatePath('.gitignore'),
      @destinationPath('.gitignore')
    @fs.copy @templatePath('.npmignore'),
      @destinationPath('.npmignore')
    @fs.copy @templatePath('coffeelint.json'),
      @destinationPath('coffeelint.json')

    @fs.copy @templatePath('src'),
      @destinationPath('src')

  install: ->
    @yarnInstall [
      'coffeescript', 'gulp@next', 'coffee-babel'
      'babel-core', 'babel-preset-env'
      'gulp-coffee', 'gulp-cson'
      'gulp-sourcemaps'
    ], dev: true
    return
