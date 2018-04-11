This is a node application generated using [generator-coffee-node](https://github.com/jhessin/generator-coffee-node).

## Usage

By default this project will compile any coffeescript you put in the `src/` directory and place it in a `lib/` directory (customizable in gulpfile.coffee). Any other files are copied directly from 'src/' to 'lib/' so they can be referenced properly.

The only files pushed to npm would be 'lib/' directory along with package.json.

Testing is done with mocha and by default any file ending in .test.coffee will be considered a test file.
