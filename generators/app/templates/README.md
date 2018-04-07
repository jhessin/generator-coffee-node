# <%=name%> [![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url] [![Dependency Status][daviddm-image]][daviddm-url] [![Coverage percentage][coveralls-image]][coveralls-url]

This is a node application generated using [generator-coffee-node](https://github.com/jhessin/generator-coffee-node).

## Usage

By default this project will compile any coffeescript you put in the `src/` directory and place it in a `lib/` directory (customizable in gulpfile.coffee).

The entry point of the program will be `src/index.coffee` by default. This can be customized by modifying your `package.json`'s `main` entry from `lib/index.js`, but it is simpler to just `import` or `require` what you need in the index.coffee file.
