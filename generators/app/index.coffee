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

    @arguments 'name',
      type: String
      required: false

    if @options.name?
      @props = @options
    else
      @props = {}

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
      projectRoot: 'generators'
      skipInstall: @options.skipInstall
      readme: readmeTpl @props
    }

  writing: ->
    pkg = @fs.readJSON @destinationPath('package.json'), {}

    pkg.keywords = pkg.keywords ? []
    pkg.keywords.push 'CoffeeScript'

    @fs.writeJSON @destinationPath('package.json'), pkg

  install: ->
    @yarnInstall ['coffeescript', 'gulp'], dev: true
    return
