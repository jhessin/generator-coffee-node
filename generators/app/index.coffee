path = require 'path'
Generator = require 'yeoman-generator'
askName = require 'inquirer-npm-name'
npmName = require 'npm-name'
validate = require 'validate-npm-package-name'
_ = require 'lodash'
extend = require 'deep-extend'
githubUsername = require 'github-username'
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
      desc: 'Name of your project'

    @option 'description',
      type: String
      required: false
      desc: 'A description of your project'

    @option 'homepage',
      type: String
      required: false
      desc: 'The homepage of your app'

    @option 'authorName',
      type: String
      required: false
      desc: 'The name of the Author'

    @option 'authorEmail',
      type: String
      required: false
      desc: 'The email of the Author'

    @option 'authorUrl',
      type: String
      required: false
      desc: 'Author homepage'

    @option 'repository',
      type: String
      required: false
      desc: 'Name of the GitHub repository'

    @props = @options ? {}
    return

  prompting: ->
    namePromise =
      if not @props.name?
        askName {
          name: 'name'
          message: 'Your generator name'
          default: path.basename(process.cwd())
        }, @
      else
        new Promise (resolve, reject) =>
          { validForNewPackages, warnings, errors } = validate @props.name
          if warnings? or errors?
            askName {
              name: 'name'
              message: "#{errors?.join('\n') ? ''}\n
                        #{warnings?.join('\n') ? ''}\n
                        Please choose another name"
            }, @
            .then ({name})-> resolve {name}
          else
            npmName @props.name
            .then (available)=>
              if not available
                askName {
                  name: 'name'
                  message: "#{@props.name} already exists on npm,
                            please choose another?"
                  default: @props.name
                }, @
                .then ({name})-> resolve {name}
              else
                resolve { name: @props.name}

    namePromise.then ({name}) =>
      @props.name = name

      if @props.name? and path.basename(@destinationPath()) isnt @props.name
        @log "Your generator must be inside a folder named #{@props.name}\n\
              I'll automatically create this folder."
        mkdirp @props.name
        @destinationRoot @destinationPath(@props.name)
      @user.github.username().then (username)=>
        @props.username = username

        @prompt [{
          name: 'description'
          when: not @props.description
          message: 'Description'
          default: 'An awesome node module that does cool stuff'
        }, {
          name: 'homepage'
          message: 'Project homepage url'
          when: not @props.homepage
          default: "https://github.com/#{@props.username}/#{@props.name}"
        }, {
          name: 'authorName'
          message: "Author's Name"
          when: not @props.authorName
          default: @user.git.name()
          store: true
        }, {
          name: 'authorEmail'
          message: "Author's Email"
          when: not @props.authorEmail
          default: @user.git.email()
          store: true
        }, {
          name: 'authorUrl'
          message: "Author's Homepage"
          when: not @props.authorUrl
          default: 'http://www.example.com'
          store: true
        }, {
          name: 'keywords'
          message: 'Package keywords (comma to split)'
          default: 'node,CoffeeScript'
          filter: (words)->
            words.split /\s*,\s*/g
        }, {
          name: 'repository'
          message: 'Project repository'
          when: not @props.repository
          default: "#{@props.username}/#{@props.name}"
        }]
        .then (props)=>
          @props = { @props..., props... }

  default: ->
    readmeTpl = _.template @fs.read(@templatePath('README.md'))

    @composeWith require.resolve('generator-license'),
      name: @props.authorName
      email: @props.authorEmail
      website: @props.authorUrl
      defaultLicense: 'MIT'

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
      engines:
        npm: '>= 4.0.0'
      scripts:
        start: 'gulp && node .'
        watch: 'gulp watch'
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
      jest:
        testEnvironment: 'node'
      devDependencies: {}
      keywords: @props.keywords
    }

    # remove the old and make room for the new
    @fs.delete @destinationPath('package.json')
    @fs.writeJSON @destinationPath('package.json'), pkg

    # TODO copy boilerplate
    @fs.copy @templatePath('.editorconfig'), @destinationPath('.editorconfig')
    @fs.copy @templatePath('.gitattributes'), @destinationPath('.gitattributes')
    @fs.copy @templatePath('.gitignore'), @destinationPath('.gitignore')
    @fs.copy @templatePath('.travis.yml'), @destinationPath('.travis.yml')
    @fs.copy @templatePath('coffeelint.json'),
      @destinationPath('coffeelint.json')
    @fs.copy @templatePath('gulpfile.coffee'),
      @destinationPath('gulpfile.coffee')

    @fs.copyTpl @templatePath('README.md'),
      @destinationPath('README.md'), @props

    @fs.copy @templatePath('src'),
      @destinationPath('src')

  install: ->
    # TODO run git init
    @spawnCommand 'git', ['init']
    # TODO add npm fallback
    pkgs = [
      'babel-core', 'babel-preset-env'
      'coffeelint', 'coffeescript'
      'gulp', 'gulp-coffee', 'gulp-cson'
      'gulp-sourcemaps', 'jest', 'nsp', 'lint-staged'
    ]

    finished = "All done. You can now run
              #{chalk.green "cd #{@props.name}"} and
              #{chalk.green 'yarn test'} or
              #{chalk.green 'yarn start'}"
    @yarnInstall pkgs, dev: true
    .then (yarnError)=>
      if yarnError then @npmInstall(pkgs, dev: true).then (npmError)=>
        if npmError then @log 'Package Manager Required.
                              Please install yarn or npm'
        else
          @log finished
      else
        @log finished
    return
