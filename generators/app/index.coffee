path = require 'path'
Generator = require 'yeoman-generator'
askName = require 'inquirer-npm-name'
_ = require 'lodash'
extend = require 'deep-extend'
mkdirp = require 'mkdirp'
rimraf = require 'rimraf'
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

    # TODO: Prompt for description, homepage, regository,
    # authorName, authorEmail, authorUrl
  default: ->
    if path.basename(@destinationPath()) isnt @props.name
      @log "Your generator must be inside a folder named #{@props.name}\n\
      I'll automatically create this folder."
      mkdirp @props.name
      @destinationRoot @destinationPath(@props.name)
    readmeTpl = _.template @fs.read(@templatePath('README.md'))

    @composeWith require.resolve('generator-license')

  writing: ->
    pkg = @fs.readJSON @destinationPath('package.json'), {
      name: @props.name
      version: "0.0.0"
      description: @props.description
      homepage: @props.homepage
      repository: @props.repository
      author:
        name: @props.authorName
        email: @props.authorEmail
        url: @props.authorUrl
      main: 'lib/index.js'
      scripts:
        pretest: 'gulp'
        postinstall: 'gulp'
        prepublishOnly: 'nsp check'
        precommit: 'lint-staged'
        test: 'jest'
      'lint-staged':
        '*.coffee': [
          'coffeelint',
          'git add'
        ]
      keywords: [
        'node',
        'CoffeeScript'
      ]
    }

    # remove the old and make room for the new
    @fs.delete @destinationPath('package.json')
    @fs.write @destinationPath('package.json'), JSON.stringify pkg

    # TODO copy boilerplate
    @fs.copy @templatePath('gulpfile.coffee'),
      @destinationPath('gulpfile.coffee')

    @fs.copy @templatePath('src'),
      @destinationPath('src')

  install: ->
    # TODO run git init
    @yarnInstall [
      'coffeescript', 'gulp'
      'babel-core', 'babel-preset-env'
      'gulp-coffee', 'gulp-cson'
      'gulp-sourcemaps'
    ], dev: true
    return
