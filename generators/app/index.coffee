Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class extends Generator
  prompting: ->
    # Have Yeoman greet the user.
    @log yosay "Welcome to the scrumtrulescent
      #{chalk.red('generator-coffee-node')} generator!"

    prompts = [
      {
        type: 'confirm',
        name: 'someAnswer',
        message: 'Would you like to enable this option?',
        default: true
      }
    ]

    # To access props later use @props.someAnswer
    @prompt(prompts).then (@props)=>

  writing: ->
    @fs.copy @templatePath('dummyfile.txt'),
      @destinationPath('dummyfile.txt')

    @fs.copy @templatePath('somefile.coffee'),
      @destinationPath('somefile.coffee')

  install: ->
    # right now there is nothing to install but if there were here you would do it.
    # @installDependencies { bower: false }
    return # be sure to put this after any intsallation to ensure it finishes.
