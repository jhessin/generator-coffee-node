path = require 'path'
Generator = require 'yeoman-generator'
askName = require 'inquirer-npm-name'
_ = require 'lodash'
extend = require 'deep-extend'
mkdirp = require 'mkdirp'
chalk = require 'chalk'
yosay = require 'yosay'

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
    if not @props.name?
      askName {
        name: 'name'
        message: 'Your generator name'
        default: path.basename(process.cwd())
      }, this
      .then (props) =>
        @props.name = props.name
  default: ->
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

  writing: ->
    @fs.extendJSON @destinationPath('package.json'), {
      scripts:
        pretest: 'coffeelint src && gulp'
        install: 'gulp'
      'lint-staged':
        '*.coffee': [
          'coffeelint',
          'git add'
        ]
    }

    @fs.copy @templatePath('gulpfile.coffee'),
      @destinationPath('gulpfile.coffee')

    @fs.copy @templatePath('src'),
      @destinationPath('src')

  install: ->
    @yarnInstall [
      'coffeescript', 'gulp'
      'babel-core', 'babel-preset-env'
      'gulp-coffee', 'gulp-cson'
      'gulp-sourcemaps'
    ], dev: true
    return
