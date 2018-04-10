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

  default: ->
    if path.basename(@destinationPath()) isnt @props.name
      @log "Your generator must be inside a folder named #{@props.name}\n\
      I'll automatically create this folder."
      mkdirp @props.name
      @destinationRoot @destinationPath(@props.name)
    readmeTpl = _.template @fs.read(@templatePath('README.md'))

    @log chalk.yellow('composing with generator-node')
    @composeWith require.resolve('generator-node/generators/app'),
      name: @props.name
      boilerplate: false
      projectRoot: 'lib'
      skipInstall: true
      readme: readmeTpl @props
    @log chalk.green('done with generator-node')

  writing: ->
    @composeWith require.resolve('../subgenerator', {})
